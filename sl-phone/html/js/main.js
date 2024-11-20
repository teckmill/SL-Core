// Main phone functionality
const Phone = {
    isOpen: false,
    currentApp: null,
    apps: {
        phone: { icon: 'phone', label: 'Phone' },
        messages: { icon: 'comment', label: 'Messages' },
        contacts: { icon: 'address-book', label: 'Contacts' },
        twitter: { icon: 'twitter', label: 'Twitter' },
        bank: { icon: 'university', label: 'Bank' },
        camera: { icon: 'camera', label: 'Camera' }
    },

    init() {
        this.setupEventListeners();
        this.setupApps();
        this.updateTime();
        setInterval(() => this.updateTime(), 1000);
    },

    setupEventListeners() {
        // Home button
        document.querySelector('.home-button').addEventListener('click', () => this.goHome());

        // Back buttons
        document.querySelectorAll('.back-btn').forEach(btn => {
            btn.addEventListener('click', () => this.goHome());
        });

        // Listen for NUI messages
        window.addEventListener('message', (event) => {
            const data = event.data;

            switch (data.action) {
                case 'open':
                    this.open();
                    break;
                case 'close':
                    this.close();
                    break;
                case 'toggle':
                    this.toggle();
                    break;
                case 'updateData':
                    this.updateData(data.data);
                    break;
            }
        });

        // Close on escape key
        document.addEventListener('keyup', (e) => {
            if (e.key === 'Escape') {
                this.close();
                this.sendNUIMessage({ action: 'close' });
            }
        });
    },

    setupApps() {
        const appGrid = document.querySelector('.app-grid');
        
        // Create app icons
        Object.entries(this.apps).forEach(([id, app]) => {
            const appIcon = document.createElement('div');
            appIcon.className = 'app-icon';
            appIcon.innerHTML = `
                <i class="fas fa-${app.icon}"></i>
                <span>${app.label}</span>
            `;
            appIcon.addEventListener('click', () => this.openApp(id));
            appGrid.appendChild(appIcon);
        });
    },

    updateTime() {
        const now = new Date();
        const timeString = now.toLocaleTimeString('en-US', { 
            hour: 'numeric', 
            minute: '2-digit',
            hour12: true 
        });
        document.querySelector('.time').textContent = timeString;
    },

    open() {
        if (!this.isOpen) {
            document.querySelector('.phone-container').classList.add('active');
            this.isOpen = true;
        }
    },

    close() {
        if (this.isOpen) {
            document.querySelector('.phone-container').classList.remove('active');
            this.isOpen = false;
            this.goHome();
        }
    },

    toggle() {
        this.isOpen ? this.close() : this.open();
    },

    goHome() {
        document.querySelectorAll('.screen').forEach(screen => {
            screen.classList.remove('active');
        });
        document.getElementById('home-screen').classList.add('active');
        this.currentApp = null;
    },

    openApp(appId) {
        const appScreen = document.getElementById(`${appId}-app`);
        if (appScreen) {
            document.querySelectorAll('.screen').forEach(screen => {
                screen.classList.remove('active');
            });
            appScreen.classList.add('active');
            this.currentApp = appId;
            this.sendNUIMessage({ action: 'appOpened', app: appId });
        }
    },

    updateData(data) {
        if (this.currentApp && typeof window[`update${this.currentApp.charAt(0).toUpperCase() + this.currentApp.slice(1)}Data`] === 'function') {
            window[`update${this.currentApp.charAt(0).toUpperCase() + this.currentApp.slice(1)}Data`](data);
        }
    },

    sendNUIMessage(data) {
        fetch(`https://${GetParentResourceName()}/phoneEvent`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(data)
        });
    },

    // Utility functions
    formatTime(timestamp) {
        const date = new Date(timestamp);
        return date.toLocaleTimeString('en-US', { 
            hour: 'numeric', 
            minute: '2-digit',
            hour12: true 
        });
    },

    formatDate(timestamp) {
        const date = new Date(timestamp);
        return date.toLocaleDateString('en-US', { 
            month: 'short', 
            day: 'numeric' 
        });
    },

    formatCurrency(amount) {
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD'
        }).format(amount);
    }
};

// Initialize phone when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    Phone.init();
});
