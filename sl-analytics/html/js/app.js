const App = {
    data: {
        currentBusiness: null,
        currentSection: 'overview',
        lastUpdate: null,
        analytics: null
    },

    // Initialize the application
    initialize: () => {
        App.setupEventListeners();
        App.setupNuiCallbacks();
    },

    // Setup event listeners
    setupEventListeners: () => {
        // Menu navigation
        document.querySelectorAll('.menu-item').forEach(item => {
            item.addEventListener('click', () => {
                App.switchSection(item.dataset.section);
            });
        });

        // Button actions
        document.getElementById('refresh-btn').addEventListener('click', App.refreshData);
        document.getElementById('export-btn').addEventListener('click', App.showExportModal);
        document.getElementById('close-btn').addEventListener('click', App.close);

        // Report form
        document.getElementById('report-form').addEventListener('submit', (e) => {
            e.preventDefault();
            App.generateReport();
        });
    },

    // Setup NUI callbacks
    setupNuiCallbacks: () => {
        window.addEventListener('message', (event) => {
            const data = event.data;

            switch (data.action) {
                case 'toggleDashboard':
                    App.toggleDashboard(data.show, data.theme);
                    break;
                case 'updateDashboard':
                    App.updateDashboard(data.data);
                    break;
                case 'displayReport':
                    App.displayReport(data.report);
                    break;
                case 'showNotification':
                    App.showNotification(data.notification);
                    break;
            }
        });
    },

    // Toggle dashboard visibility
    toggleDashboard: (show, theme) => {
        const dashboard = document.getElementById('app');
        dashboard.style.display = show ? 'flex' : 'none';

        if (show && theme) {
            document.documentElement.style.setProperty('--primary', theme.primary);
            document.documentElement.style.setProperty('--secondary', theme.secondary);
            document.documentElement.style.setProperty('--accent', theme.accent);
        }
    },

    // Switch between dashboard sections
    switchSection: (section) => {
        // Update active menu item
        document.querySelectorAll('.menu-item').forEach(item => {
            item.classList.toggle('active', item.dataset.section === section);
        });

        // Update active section
        document.querySelectorAll('.section').forEach(s => {
            s.classList.toggle('active', s.id === section);
        });

        App.data.currentSection = section;
        App.updateSectionContent(section);
    },

    // Update section content
    updateSectionContent: (section) => {
        if (!App.data.analytics) return;

        const sectionElement = document.getElementById(section);
        if (!sectionElement) return;

        switch (section) {
            case 'overview':
                App.updateOverviewSection();
                break;
            case 'financial':
                App.updateFinancialSection();
                break;
            case 'inventory':
                App.updateInventorySection();
                break;
            case 'employees':
                App.updateEmployeesSection();
                break;
            case 'customers':
                App.updateCustomersSection();
                break;
            case 'operations':
                App.updateOperationsSection();
                break;
        }
    },

    // Update overview section
    updateOverviewSection: () => {
        const data = App.data.analytics;
        if (!data) return;

        // Update metric cards
        document.getElementById('overview-revenue').textContent = Config.format.currency.format(data.financial.revenue);
        document.getElementById('overview-profit').textContent = Config.format.currency.format(data.financial.profit);
        document.getElementById('overview-customers').textContent = Config.format.number.format(data.customers.total);
        document.getElementById('overview-performance').textContent = Config.format.percent.format(data.employees.avgPerformance / 100);

        // Update charts
        Charts.updateAll({
            revenue: data.revenue,
            customers: data.customers,
            financial: data.financial,
            employees: data.employees
        });
    },

    // Refresh dashboard data
    refreshData: () => {
        fetch(`https://${GetParentResourceName()}/refreshData`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        });
    },

    // Update dashboard with new data
    updateDashboard: (data) => {
        App.data.analytics = data;
        App.data.lastUpdate = new Date();

        // Update last updated timestamp
        document.getElementById('last-updated').textContent = `Last updated: ${Config.format.time.format(App.data.lastUpdate)}`;

        // Update current section
        App.updateSectionContent(App.data.currentSection);
    },

    // Show export modal
    showExportModal: () => {
        const modal = document.getElementById('report-modal');
        modal.classList.add('active');
    },

    // Generate report
    generateReport: () => {
        const form = document.getElementById('report-form');
        const data = {
            type: form.querySelector('#report-type').value,
            dateRange: form.querySelector('#date-range').value,
            format: form.querySelector('#export-format').value
        };

        fetch(`https://${GetParentResourceName()}/generateReport`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });

        // Hide modal
        document.getElementById('report-modal').classList.remove('active');
    },

    // Display generated report
    displayReport: (report) => {
        // Implementation depends on report format and display requirements
        console.log('Report received:', report);
    },

    // Show notification
    showNotification: (data) => {
        const container = document.getElementById('notifications');
        const notification = document.createElement('div');
        
        notification.className = `notification ${data.type}`;
        notification.innerHTML = `
            <i class="${Config.notifications.types[data.type].icon}"></i>
            <div class="notification-content">
                <h4>${data.title}</h4>
                <p>${data.message}</p>
            </div>
        `;

        container.appendChild(notification);

        // Auto remove after duration
        setTimeout(() => {
            notification.style.animation = 'slideOut 0.3s ease forwards';
            setTimeout(() => {
                container.removeChild(notification);
            }, 300);
        }, data.duration || Config.notifications.duration);
    },

    // Close dashboard
    close: () => {
        fetch(`https://${GetParentResourceName()}/close`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        });
    }
};

// Initialize app when DOM is loaded
document.addEventListener('DOMContentLoaded', App.initialize);
