let currentAccount = null;

$(document).ready(function() {
    // Initialize event listeners
    initializeEventListeners();
    
    // Listen for NUI messages
    window.addEventListener('message', function(event) {
        const data = event.data;

        switch (data.action) {
            case 'openBank':
                openBankingInterface(data);
                break;
            case 'openATM':
                openATMInterface(data);
                break;
            case 'updateAccounts':
                updateAccounts(data.accounts);
                break;
            case 'updateTransactions':
                updateTransactions(data.transactions);
                break;
            case 'updateInvestments':
                updateInvestments(data.investments);
                break;
            case 'updateLoans':
                updateLoans(data.loans);
                break;
            case 'notify':
                showNotification(data.message, data.type);
                break;
        }
    });
});

function initializeEventListeners() {
    // Navigation
    $('.nav-link').click(function() {
        const tab = $(this).data('tab');
        $('.nav-link').removeClass('active');
        $(this).addClass('active');
        $('.content-tab').removeClass('active');
        $(`#${tab}`).addClass('active');
    });

    // Close buttons
    $('#close-banking').click(closeBankingInterface);
    $('#close-atm').click(closeATMInterface);

    // Forms
    $('#transfer-form').submit(handleTransfer);
    $('#withdraw-form').submit(handleWithdraw);
    $('#deposit-form').submit(handleDeposit);
    $('#investment-form').submit(handleInvestment);
    $('#loan-form').submit(handleLoan);
}

// Interface Management
function openBankingInterface(data) {
    $('#banking-container').removeClass('d-none').addClass('fade-in');
    updateAccounts(data.accounts);
    updateTransactions(data.transactions);
    updateInvestments(data.investments);
    updateLoans(data.loans);
    populateInvestmentTypes();
    populateLoanTypes();
}

function openATMInterface(data) {
    $('#atm-container').removeClass('d-none').addClass('fade-in');
    updateATMAccounts(data.accounts);
}

function closeBankingInterface() {
    $('#banking-container').addClass('d-none');
    $.post('https://sl-banking/closeBank');
}

function closeATMInterface() {
    $('#atm-container').addClass('d-none');
    $.post('https://sl-banking/closeATM');
}

// Update UI Functions
function updateAccounts(accounts) {
    const accountsList = $('#accounts-list');
    accountsList.empty();

    accounts.forEach(account => {
        accountsList.append(`
            <div class="col-md-6 mb-4">
                <div class="account-card">
                    <h4>${account.type} Account</h4>
                    <p class="text-muted">Account #: ${account.number}</p>
                    <div class="balance">$${formatMoney(account.balance)}</div>
                    <div class="mt-3">
                        <button class="btn btn-sm btn-primary me-2" onclick="handleQuickDeposit('${account.number}')">
                            Quick Deposit
                        </button>
                        <button class="btn btn-sm btn-primary" onclick="handleQuickWithdraw('${account.number}')">
                            Quick Withdraw
                        </button>
                    </div>
                </div>
            </div>
        `);

        // Update transfer account options
        $('#transfer-from').append(`<option value="${account.number}">${account.type} - ${account.number}</option>`);
    });
}

function updateATMAccounts(accounts) {
    const atmAccounts = $('#atm-accounts');
    atmAccounts.empty();

    accounts.forEach(account => {
        atmAccounts.append(`
            <div class="card mb-3">
                <div class="card-body">
                    <h5 class="card-title">${account.type} Account</h5>
                    <p class="card-text">Account #: ${account.number}</p>
                    <h4 class="text-success">$${formatMoney(account.balance)}</h4>
                </div>
            </div>
        `);
    });
}

function updateTransactions(transactions) {
    const transactionsList = $('#transactions-list tbody');
    transactionsList.empty();

    transactions.forEach(transaction => {
        transactionsList.append(`
            <tr>
                <td>${formatDate(transaction.date)}</td>
                <td>${transaction.description}</td>
                <td class="${transaction.amount >= 0 ? 'text-success' : 'text-danger'}">
                    ${transaction.amount >= 0 ? '+' : ''}$${formatMoney(Math.abs(transaction.amount))}
                </td>
                <td>$${formatMoney(transaction.balance)}</td>
            </tr>
        `);
    });
}

function updateInvestments(investments) {
    const investmentsList = $('#investments-list');
    investmentsList.empty();

    investments.forEach(investment => {
        investmentsList.append(`
            <div class="col-md-6 mb-4">
                <div class="investment-card">
                    <h4>${investment.type}</h4>
                    <p class="text-muted">Investment #: ${investment.id}</p>
                    <div class="amount">Amount: $${formatMoney(investment.amount)}</div>
                    <div class="return-rate">Return Rate: ${investment.returnRate}%</div>
                    <div class="mt-3">
                        <button class="btn btn-sm btn-primary" onclick="handleInvestmentWithdraw('${investment.id}')">
                            Withdraw Investment
                        </button>
                    </div>
                </div>
            </div>
        `);
    });
}

function updateLoans(loans) {
    const loansList = $('#loans-list');
    loansList.empty();

    loans.forEach(loan => {
        loansList.append(`
            <div class="col-md-6 mb-4">
                <div class="loan-card">
                    <h4>${loan.type}</h4>
                    <p class="text-muted">Loan #: ${loan.id}</p>
                    <div class="amount">Amount: $${formatMoney(loan.amount)}</div>
                    <div class="interest-rate">Interest Rate: ${loan.interestRate}%</div>
                    <div class="remaining">Remaining: $${formatMoney(loan.remaining)}</div>
                    <div class="mt-3">
                        <button class="btn btn-sm btn-primary" onclick="handleLoanPayment('${loan.id}')">
                            Make Payment
                        </button>
                    </div>
                </div>
            </div>
        `);
    });
}

// Form Handlers
function handleTransfer(e) {
    e.preventDefault();
    const data = {
        from: $('#transfer-from').val(),
        to: $('#transfer-to').val(),
        amount: parseFloat($('#transfer-amount').val())
    };

    if (!data.from || !data.to || !data.amount) {
        showNotification('Please fill in all fields', 'error');
        return;
    }

    $.post('https://sl-banking/transfer', JSON.stringify(data));
    $('#transfer-form')[0].reset();
}

function handleWithdraw(e) {
    e.preventDefault();
    const amount = parseFloat($('#withdraw-amount').val());

    if (!amount) {
        showNotification('Please enter an amount', 'error');
        return;
    }

    $.post('https://sl-banking/withdraw', JSON.stringify({ amount }));
    $('#withdraw-form')[0].reset();
}

function handleDeposit(e) {
    e.preventDefault();
    const amount = parseFloat($('#deposit-amount').val());

    if (!amount) {
        showNotification('Please enter an amount', 'error');
        return;
    }

    $.post('https://sl-banking/deposit', JSON.stringify({ amount }));
    $('#deposit-form')[0].reset();
}

function handleInvestment(e) {
    e.preventDefault();
    const data = {
        type: $('#investment-type').val(),
        amount: parseFloat($('#investment-amount').val())
    };

    if (!data.type || !data.amount) {
        showNotification('Please fill in all fields', 'error');
        return;
    }

    $.post('https://sl-banking/createInvestment', JSON.stringify(data));
    $('#investment-form')[0].reset();
}

function handleLoan(e) {
    e.preventDefault();
    const data = {
        type: $('#loan-type').val(),
        amount: parseFloat($('#loan-amount').val()),
        term: parseInt($('#loan-term').val())
    };

    if (!data.type || !data.amount || !data.term) {
        showNotification('Please fill in all fields', 'error');
        return;
    }

    $.post('https://sl-banking/requestLoan', JSON.stringify(data));
    $('#loan-form')[0].reset();
}

// Quick Actions
function handleQuickDeposit(accountNumber) {
    currentAccount = accountNumber;
    $('#deposit-amount').focus();
}

function handleQuickWithdraw(accountNumber) {
    currentAccount = accountNumber;
    $('#withdraw-amount').focus();
}

function handleInvestmentWithdraw(investmentId) {
    $.post('https://sl-banking/withdrawInvestment', JSON.stringify({ id: investmentId }));
}

function handleLoanPayment(loanId) {
    $.post('https://sl-banking/payLoan', JSON.stringify({ id: loanId }));
}

// Utility Functions
function formatMoney(amount) {
    return amount.toLocaleString('en-US', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    });
}

function formatDate(date) {
    return new Date(date).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

function showNotification(message, type) {
    // Implement notification system here
    console.log(`${type}: ${message}`);
}

// Populate Select Options
function populateInvestmentTypes() {
    const types = [
        { id: 'stocks', name: 'Stocks' },
        { id: 'bonds', name: 'Bonds' },
        { id: 'crypto', name: 'Cryptocurrency' }
    ];

    const select = $('#investment-type');
    select.empty();
    types.forEach(type => {
        select.append(`<option value="${type.id}">${type.name}</option>`);
    });
}

function populateLoanTypes() {
    const types = [
        { id: 'personal', name: 'Personal Loan' },
        { id: 'business', name: 'Business Loan' },
        { id: 'mortgage', name: 'Mortgage' }
    ];

    const select = $('#loan-type');
    select.empty();
    types.forEach(type => {
        select.append(`<option value="${type.id}">${type.name}</option>`);
    });
}
