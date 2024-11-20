-- Payroll Database Schema

-- Employee Payroll Information
CREATE TABLE IF NOT EXISTS employee_payroll (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizen_id VARCHAR(50) NOT NULL,
    business_id INT NOT NULL,
    position VARCHAR(50) NOT NULL,
    base_rate DECIMAL(10, 2) NOT NULL,
    pay_type ENUM('hourly', 'salary') DEFAULT 'hourly',
    pay_frequency ENUM('daily', 'weekly', 'biweekly', 'monthly') DEFAULT 'weekly',
    tax_withholding DECIMAL(5, 2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    INDEX idx_citizen (citizen_id),
    INDEX idx_business (business_id)
);

-- Employee Benefits
CREATE TABLE IF NOT EXISTS employee_benefits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    healthcare_plan VARCHAR(50),
    retirement_contribution DECIMAL(5, 2),
    pto_balance DECIMAL(10, 2) DEFAULT 0,
    pto_used DECIMAL(10, 2) DEFAULT 0,
    insurance_plan VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employee_payroll(id) ON DELETE CASCADE,
    INDEX idx_employee (employee_id)
);

-- Time Tracking
CREATE TABLE IF NOT EXISTS time_entries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    clock_in TIMESTAMP NOT NULL,
    clock_out TIMESTAMP,
    regular_hours DECIMAL(10, 2) DEFAULT 0,
    overtime_hours DECIMAL(10, 2) DEFAULT 0,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    approved_by VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employee_payroll(id) ON DELETE CASCADE,
    INDEX idx_employee (employee_id),
    INDEX idx_date (clock_in)
);

-- Payroll Transactions
CREATE TABLE IF NOT EXISTS payroll_transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    pay_period_start DATE NOT NULL,
    pay_period_end DATE NOT NULL,
    regular_hours DECIMAL(10, 2) DEFAULT 0,
    overtime_hours DECIMAL(10, 2) DEFAULT 0,
    gross_pay DECIMAL(10, 2) NOT NULL,
    net_pay DECIMAL(10, 2) NOT NULL,
    tax_withheld DECIMAL(10, 2) DEFAULT 0,
    deductions DECIMAL(10, 2) DEFAULT 0,
    benefits_cost DECIMAL(10, 2) DEFAULT 0,
    bonus_amount DECIMAL(10, 2) DEFAULT 0,
    payment_method VARCHAR(20) NOT NULL,
    status ENUM('pending', 'processed', 'failed') DEFAULT 'pending',
    processed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employee_payroll(id) ON DELETE CASCADE,
    INDEX idx_employee (employee_id),
    INDEX idx_period (pay_period_start, pay_period_end)
);

-- Deductions and Contributions
CREATE TABLE IF NOT EXISTS payroll_deductions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT NOT NULL,
    type VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES payroll_transactions(id) ON DELETE CASCADE,
    INDEX idx_transaction (transaction_id)
);

-- Bonuses and Adjustments
CREATE TABLE IF NOT EXISTS payroll_adjustments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    type VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    reason TEXT,
    status ENUM('pending', 'approved', 'rejected', 'processed') DEFAULT 'pending',
    approved_by VARCHAR(50),
    processed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employee_payroll(id) ON DELETE CASCADE,
    INDEX idx_employee (employee_id)
);

-- Payroll Audit Log
CREATE TABLE IF NOT EXISTS payroll_audit_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id INT NOT NULL,
    changes TEXT,
    performed_by VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_entity (entity_type, entity_id),
    INDEX idx_action (action_type)
);

-- Tax Documents
CREATE TABLE IF NOT EXISTS tax_documents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    document_type VARCHAR(50) NOT NULL,
    tax_year INT NOT NULL,
    total_earnings DECIMAL(10, 2) NOT NULL,
    total_tax_withheld DECIMAL(10, 2) NOT NULL,
    document_data JSON,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employee_payroll(id) ON DELETE CASCADE,
    INDEX idx_employee_year (employee_id, tax_year)
);

-- Benefits Enrollment Periods
CREATE TABLE IF NOT EXISTS benefit_enrollment_periods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    business_id INT NOT NULL,
    enrollment_start DATE NOT NULL,
    enrollment_end DATE NOT NULL,
    benefit_year INT NOT NULL,
    status ENUM('upcoming', 'active', 'closed') DEFAULT 'upcoming',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    INDEX idx_business (business_id),
    INDEX idx_period (enrollment_start, enrollment_end)
);

-- PTO Requests
CREATE TABLE IF NOT EXISTS pto_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    hours_requested DECIMAL(10, 2) NOT NULL,
    request_type ENUM('vacation', 'sick', 'personal') NOT NULL,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    approved_by VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employee_payroll(id) ON DELETE CASCADE,
    INDEX idx_employee (employee_id),
    INDEX idx_dates (start_date, end_date)
);
