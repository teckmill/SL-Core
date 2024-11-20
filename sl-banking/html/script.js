let config = {};
const bankApp = new Vue({
    el: '#app',
    data: {
        showMenu: false,
        currentTab: 'accounts',
        loading: false,
        notification: {
            show: false,
            message: '',
            type: 'success'
        },
        accounts: [],
        transactions: [],
        selectedAccount: null,
        transferData: {
            amount: 0,
            targetAccount: '',
            description: ''
        }
    },
    methods: {
        // Initialize the bank app
        init(data) {
            config = data.config;
            this.accounts = data.accounts;
            this.transactions = data.transactions;
            this.showMenu = true;
        },

        // Switch between tabs
        setTab(tab) {
            this.currentTab = tab;
        },

        // Format currency
        formatCurrency(amount) {
            return new Intl.NumberFormat('en-US', {
                style: 'currency',
                currency: 'USD'
            }).format(amount);
        },

        // Show notification
        showNotification(message, type = 'success') {
            this.notification = {
                show: true,
                message,
                type
            };
            setTimeout(() => {
                this.notification.show = false;
            }, 3000);
        },

        // Handle deposit
        async deposit() {
            if (!this.selectedAccount) return;
            this.loading = true;
            try {
                await $.post('https://sl-banking/deposit', JSON.stringify({
                    account: this.selectedAccount.id,
                    amount: this.transferData.amount
                }));
                this.showNotification('Deposit successful');
                this.refreshData();
            } catch (error) {
                this.showNotification('Deposit failed', 'error');
            }
            this.loading = false;
        },

        // Handle withdrawal
        async withdraw() {
            if (!this.selectedAccount) return;
            this.loading = true;
            try {
                await $.post('https://sl-banking/withdraw', JSON.stringify({
                    account: this.selectedAccount.id,
                    amount: this.transferData.amount
                }));
                this.showNotification('Withdrawal successful');
                this.refreshData();
            } catch (error) {
                this.showNotification('Withdrawal failed', 'error');
            }
            this.loading = false;
        },

        // Handle transfer
        async transfer() {
            if (!this.selectedAccount) return;
            this.loading = true;
            try {
                await $.post('https://sl-banking/transfer', JSON.stringify({
                    sourceAccount: this.selectedAccount.id,
                    targetAccount: this.transferData.targetAccount,
                    amount: this.transferData.amount,
                    description: this.transferData.description
                }));
                this.showNotification('Transfer successful');
                this.refreshData();
            } catch (error) {
                this.showNotification('Transfer failed', 'error');
            }
            this.loading = false;
        },

        // Refresh account data
        async refreshData() {
            try {
                const response = await $.post('https://sl-banking/refreshData', JSON.stringify({}));
                this.accounts = response.accounts;
                this.transactions = response.transactions;
            } catch (error) {
                this.showNotification('Failed to refresh data', 'error');
            }
        },

        // Close the bank app
        close() {
            this.showMenu = false;
            $.post('https://sl-banking/closeBank', JSON.stringify({}));
        }
    }
});

// Handle escape key
document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
        bankApp.close();
    }
});

// Handle messages from the game client
window.addEventListener('message', (event) => {
    const data = event.data;
    switch (data.action) {
        case 'init':
            bankApp.init(data);
            break;
        case 'refreshData':
            bankApp.refreshData();
            break;
        case 'showNotification':
            bankApp.showNotification(data.message, data.type);
            break;
    }
});
