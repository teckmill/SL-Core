const NotificationManager = {
    queue: [],
    containers: {},
    config: null,
    
    init() {
        // Initialize containers
        const positions = [
            'top-left', 'top-right', 'top-center',
            'bottom-left', 'bottom-right', 'bottom-center',
            'center-left', 'center-right', 'center'
        ];
        
        positions.forEach(position => {
            this.containers[position] = document.getElementById(`notifications-container-${position}`);
        });
        
        // Listen for messages from the game
        window.addEventListener('message', this.handleMessage.bind(this));
    },
    
    handleMessage(event) {
        const data = event.data;
        
        if (data.action === 'notify') {
            this.showNotification(data.data);
        } else if (data.action === 'config') {
            this.config = data.data;
        }
    },
    
    showNotification(data) {
        const settings = { ...this.config?.DefaultSettings, ...data };
        
        if (settings.Queue && this.queue.length >= this.config?.Queue.MaxSize) {
            this.queue.push(data);
            return;
        }
        
        const notification = this.createNotificationElement(settings);
        const container = this.containers[settings.Position];
        
        if (!container) return;
        
        container.appendChild(notification);
        
        // Trigger animation
        setTimeout(() => {
            notification.classList.add('show');
        }, 10);
        
        // Start progress bar
        if (settings.Progress && settings.Duration > 0) {
            const progressBar = notification.querySelector('.notification-progress-bar');
            progressBar.style.transition = `width ${settings.Duration}ms linear`;
            progressBar.style.width = '0';
        }
        
        // Play sound
        if (settings.Sound) {
            const audio = new Audio(`sounds/${this.config.Sounds.Files[settings.Type]}`);
            audio.volume = this.config.Sounds.Volume;
            audio.play();
        }
        
        // Auto close
        if (settings.Duration > 0) {
            setTimeout(() => {
                this.closeNotification(notification);
            }, settings.Duration);
        }
    },
    
    createNotificationElement(settings) {
        const notification = document.createElement('div');
        notification.className = `notification ${settings.Type} ${settings.Theme}`;
        
        // Icon
        if (settings.Icon) {
            const icon = document.createElement('div');
            icon.className = 'notification-icon';
            icon.innerHTML = this.getIconSVG(settings.Type);
            notification.appendChild(icon);
        }
        
        // Content
        const content = document.createElement('div');
        content.className = 'notification-content';
        
        if (settings.Title) {
            const title = document.createElement('div');
            title.className = 'notification-title';
            title.textContent = settings.Title;
            content.appendChild(title);
        }
        
        const message = document.createElement('div');
        message.className = 'notification-message';
        message.textContent = settings.Message;
        content.appendChild(message);
        
        notification.appendChild(content);
        
        // Close button
        if (settings.Closable) {
            const close = document.createElement('div');
            close.className = 'notification-close';
            close.innerHTML = '×';
            close.onclick = () => this.closeNotification(notification);
            notification.appendChild(close);
        }
        
        // Progress bar
        if (settings.Progress && settings.Duration > 0) {
            const progress = document.createElement('div');
            progress.className = 'notification-progress';
            const progressBar = document.createElement('div');
            progressBar.className = 'notification-progress-bar';
            progress.appendChild(progressBar);
            notification.appendChild(progress);
        }
        
        return notification;
    },
    
    closeNotification(notification) {
        notification.classList.remove('show');
        
        setTimeout(() => {
            notification.remove();
            
            // Process queue
            if (this.queue.length > 0 && this.config?.Queue.Enabled) {
                const next = this.queue.shift();
                this.showNotification(next);
            }
        }, this.config?.Animations.Duration || 300);
    },
    
    getIconSVG(type) {
        const icons = {
            success: '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z"/></svg>',
            error: '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12 19 6.41z"/></svg>',
            info: '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/></svg>',
            warning: '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/></svg>',
            system: '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>'
        };
        
        return icons[type] || icons.info;
    }
};

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    NotificationManager.init();
});
