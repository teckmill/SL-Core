// Global state
let currentTheme = 'light';
let notificationSettings = {
    reports: true,
    players: true
};

// NUI Message handler
window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch (data.type) {
        case 'show':
            document.getElementById('app').classList.remove('hidden');
            break;
            
        case 'hide':
            document.getElementById('app').classList.add('hidden');
            break;
            
        case 'updatePlayers':
            updatePlayersList(data.players);
            updateDashboardStats();
            break;
            
        case 'updateReports':
            updateReportsList(data.reports);
            updateDashboardStats();
            break;
            
        case 'updateBans':
            updateBansList(data.bans);
            updateDashboardStats();
            break;
            
        case 'notification':
            showNotification(data.message, data.notificationType);
            break;
    }
});

// Theme management
function setTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    currentTheme = theme;
    localStorage.setItem('sl-admin-theme', theme);
}

function toggleTheme() {
    const newTheme = currentTheme === 'light' ? 'dark' : 'light';
    setTheme(newTheme);
}

// Notification system
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.classList.add('show');
    }, 100);
    
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => {
            notification.remove();
        }, 300);
    }, 3000);
}

// Dashboard stats
function updateDashboardStats() {
    const onlinePlayers = Object.keys(window.players || {}).length;
    const activeReports = Object.values(window.reports || {}).filter(r => r.status !== 'closed').length;
    const activeBans = Object.keys(window.bans || {}).length;
    
    document.getElementById('online-players').textContent = onlinePlayers;
    document.getElementById('active-reports').textContent = activeReports;
    document.getElementById('active-bans').textContent = activeBans;
}

// Modal management
function openModal(content, options = {}) {
    const modal = document.getElementById('modal');
    const modalBody = modal.querySelector('.modal-body');
    
    modalBody.innerHTML = content;
    
    if (options.width) {
        modal.querySelector('.modal-content').style.maxWidth = options.width;
    }
    
    modal.classList.remove('hidden');
}

function closeModal() {
    const modal = document.getElementById('modal');
    modal.classList.add('hidden');
}

// Utility functions
function formatDate(timestamp) {
    return new Date(timestamp * 1000).toLocaleString();
}

function formatDuration(seconds) {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    
    if (hours > 0) {
        return `${hours}h ${minutes}m`;
    }
    return `${minutes}m`;
}

// NUI callbacks
function sendNUICallback(action, data = {}) {
    fetch(`https://${GetParentResourceName()}/${action}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    });
}

// Event listeners
document.addEventListener('DOMContentLoaded', function() {
    // Load saved theme
    const savedTheme = localStorage.getItem('sl-admin-theme') || 'light';
    setTheme(savedTheme);
    
    // Close modal on background click
    document.getElementById('modal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeModal();
        }
    });
    
    // Close modal on X click
    document.querySelector('.modal .close').addEventListener('click', closeModal);
    
    // ESC key to close modal or panel
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            if (!document.getElementById('modal').classList.contains('hidden')) {
                closeModal();
            } else if (!document.getElementById('app').classList.contains('hidden')) {
                sendNUICallback('close');
            }
        }
    });
});
