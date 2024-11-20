DELIMITER //

-- Create a new bank account
CREATE PROCEDURE `create_bank_account`(
    IN p_owner_identifier VARCHAR(50),
    IN p_type ENUM('checking', 'savings', 'business'),
    IN p_pin VARCHAR(6)
)
BEGIN
    DECLARE v_account_number VARCHAR(20);
    
    -- Generate unique account number
    SET v_account_number = CONCAT('SL', LPAD(FLOOR(RAND() * 1000000000), 9, '0'));
    
    INSERT INTO sl_bank_accounts (account_number, owner_identifier, type, pin)
    VALUES (v_account_number, p_owner_identifier, p_type, p_pin);
    
    SELECT * FROM sl_bank_accounts WHERE id = LAST_INSERT_ID();
END //

-- Get account details with balance
CREATE PROCEDURE `get_account_details`(
    IN p_account_number VARCHAR(20)
)
BEGIN
    SELECT a.*, 
           COALESCE(SUM(CASE WHEN i.status = 'active' THEN i.amount ELSE 0 END), 0) as total_investments,
           COALESCE(SUM(CASE WHEN l.status = 'active' THEN l.remaining_amount ELSE 0 END), 0) as total_loans
    FROM sl_bank_accounts a
    LEFT JOIN sl_bank_investments i ON i.account_id = a.id
    LEFT JOIN sl_bank_loans l ON l.account_id = a.id
    WHERE a.account_number = p_account_number
    GROUP BY a.id;
END //

-- Process a transaction
CREATE PROCEDURE `process_transaction`(
    IN p_account_id INT,
    IN p_type ENUM('deposit', 'withdraw', 'transfer_in', 'transfer_out', 'loan_payment', 'investment_deposit', 'investment_withdraw'),
    IN p_amount DECIMAL(15, 2),
    IN p_description VARCHAR(255),
    IN p_reference_id VARCHAR(50)
)
BEGIN
    DECLARE v_balance DECIMAL(15, 2);
    DECLARE v_new_balance DECIMAL(15, 2);
    
    -- Get current balance
    SELECT balance INTO v_balance
    FROM sl_bank_accounts
    WHERE id = p_account_id
    FOR UPDATE;
    
    -- Calculate new balance
    IF p_type IN ('deposit', 'transfer_in') THEN
        SET v_new_balance = v_balance + p_amount;
    ELSE
        SET v_new_balance = v_balance - p_amount;
    END IF;
    
    -- Update account balance
    UPDATE sl_bank_accounts
    SET balance = v_new_balance
    WHERE id = p_account_id;
    
    -- Record transaction
    INSERT INTO sl_bank_transactions (account_id, type, amount, balance_after, description, reference_id)
    VALUES (p_account_id, p_type, p_amount, v_new_balance, p_description, p_reference_id);
    
    SELECT * FROM sl_bank_transactions WHERE id = LAST_INSERT_ID();
END //

-- Create an investment
CREATE PROCEDURE `create_investment`(
    IN p_account_id INT,
    IN p_type ENUM('stocks', 'bonds', 'crypto'),
    IN p_amount DECIMAL(15, 2)
)
BEGIN
    DECLARE v_return_rate DECIMAL(5, 2);
    
    -- Set return rate based on investment type
    CASE p_type
        WHEN 'stocks' THEN SET v_return_rate = 8.00;
        WHEN 'bonds' THEN SET v_return_rate = 4.00;
        WHEN 'crypto' THEN SET v_return_rate = 12.00;
    END CASE;
    
    -- Create investment
    INSERT INTO sl_bank_investments (account_id, type, amount, return_rate)
    VALUES (p_account_id, p_type, p_amount, v_return_rate);
    
    -- Record transaction
    CALL process_transaction(p_account_id, 'investment_deposit', p_amount, 
        CONCAT('Investment in ', p_type), CONCAT('INV', LAST_INSERT_ID()));
    
    SELECT * FROM sl_bank_investments WHERE id = LAST_INSERT_ID();
END //

-- Request a loan
CREATE PROCEDURE `request_loan`(
    IN p_account_id INT,
    IN p_type ENUM('personal', 'business', 'mortgage'),
    IN p_amount DECIMAL(15, 2),
    IN p_term_months INT
)
BEGIN
    DECLARE v_credit_score INT;
    DECLARE v_interest_rate DECIMAL(5, 2);
    
    -- Get credit score
    SELECT credit_score INTO v_credit_score
    FROM sl_bank_accounts
    WHERE id = p_account_id;
    
    -- Calculate interest rate based on credit score and loan type
    SET v_interest_rate = CASE
        WHEN v_credit_score >= 800 THEN
            CASE p_type
                WHEN 'personal' THEN 6.00
                WHEN 'business' THEN 5.00
                WHEN 'mortgage' THEN 4.00
            END
        WHEN v_credit_score >= 700 THEN
            CASE p_type
                WHEN 'personal' THEN 8.00
                WHEN 'business' THEN 7.00
                WHEN 'mortgage' THEN 5.00
            END
        ELSE
            CASE p_type
                WHEN 'personal' THEN 12.00
                WHEN 'business' THEN 10.00
                WHEN 'mortgage' THEN 7.00
            END
    END;
    
    -- Create loan
    INSERT INTO sl_bank_loans (account_id, type, amount, interest_rate, term_months, remaining_amount)
    VALUES (p_account_id, p_type, p_amount, v_interest_rate, p_term_months, p_amount);
    
    SELECT * FROM sl_bank_loans WHERE id = LAST_INSERT_ID();
END //

-- Process loan payment
CREATE PROCEDURE `process_loan_payment`(
    IN p_loan_id INT,
    IN p_amount DECIMAL(15, 2)
)
BEGIN
    DECLARE v_account_id INT;
    DECLARE v_remaining DECIMAL(15, 2);
    DECLARE v_new_remaining DECIMAL(15, 2);
    
    -- Get loan details
    SELECT account_id, remaining_amount INTO v_account_id, v_remaining
    FROM sl_bank_loans
    WHERE id = p_loan_id
    FOR UPDATE;
    
    SET v_new_remaining = v_remaining - p_amount;
    
    -- Update loan
    UPDATE sl_bank_loans
    SET remaining_amount = v_new_remaining,
        status = IF(v_new_remaining <= 0, 'paid', 'active'),
        next_payment_date = DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 MONTH)
    WHERE id = p_loan_id;
    
    -- Record payment
    INSERT INTO sl_bank_loan_payments (loan_id, amount, remaining_after)
    VALUES (p_loan_id, p_amount, v_new_remaining);
    
    -- Record transaction
    CALL process_transaction(v_account_id, 'loan_payment', p_amount,
        CONCAT('Loan payment - ID: ', p_loan_id), CONCAT('LOAN', p_loan_id));
    
    SELECT * FROM sl_bank_loan_payments WHERE id = LAST_INSERT_ID();
END //

-- Update credit score
CREATE PROCEDURE `update_credit_score`(
    IN p_account_id INT,
    IN p_change INT,
    IN p_reason VARCHAR(255)
)
BEGIN
    DECLARE v_old_score INT;
    DECLARE v_new_score INT;
    
    -- Get current credit score
    SELECT credit_score INTO v_old_score
    FROM sl_bank_accounts
    WHERE id = p_account_id;
    
    SET v_new_score = GREATEST(300, LEAST(850, v_old_score + p_change));
    
    -- Update credit score
    UPDATE sl_bank_accounts
    SET credit_score = v_new_score
    WHERE id = p_account_id;
    
    -- Record change
    INSERT INTO sl_bank_credit_history (account_id, old_score, new_score, reason)
    VALUES (p_account_id, v_old_score, v_new_score, p_reason);
    
    SELECT * FROM sl_bank_credit_history WHERE id = LAST_INSERT_ID();
END //

-- Get account transactions
CREATE PROCEDURE `get_account_transactions`(
    IN p_account_id INT,
    IN p_limit INT
)
BEGIN
    SELECT t.*
    FROM sl_bank_transactions t
    WHERE t.account_id = p_account_id
    ORDER BY t.created_at DESC
    LIMIT p_limit;
END //

-- Get account investments
CREATE PROCEDURE `get_account_investments`(
    IN p_account_id INT
)
BEGIN
    SELECT i.*,
           ROUND(i.amount * (1 + (i.return_rate / 100) * 
                 TIMESTAMPDIFF(MONTH, i.start_date, CURRENT_TIMESTAMP) / 12), 2) as current_value
    FROM sl_bank_investments i
    WHERE i.account_id = p_account_id
    AND i.status = 'active';
END //

-- Get account loans
CREATE PROCEDURE `get_account_loans`(
    IN p_account_id INT
)
BEGIN
    SELECT l.*,
           (SELECT COUNT(*) FROM sl_bank_loan_payments WHERE loan_id = l.id) as payments_made
    FROM sl_bank_loans l
    WHERE l.account_id = p_account_id
    AND l.status IN ('pending', 'active');
END //

DELIMITER ;
