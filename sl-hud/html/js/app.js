// Main HUD Application
const SLHud = {
    config: null,
    elements: {},
    status: {
        visible: true,
        cinematicMode: false,
        vehicle: false,
        weapon: false,
        gang: false
    },

    // Initialize the HUD
    init() {
        this.loadConfig();
        this.cacheElements();
        this.setupEventListeners();
        this.initializeComponents();
    },

    // Load configuration
    loadConfig() {
        fetch('js/config.js')
            .then(response => response.json())
            .then(config => {
                this.config = config;
                this.applyConfig();
            })
            .catch(error => console.error('Error loading config:', error));
    },

    // Cache DOM elements
    cacheElements() {
        // Main containers
        this.elements.hudWrapper = document.getElementById('hud-wrapper');
        this.elements.statusContainer = document.getElementById('status-container');
        this.elements.vehicleContainer = document.getElementById('vehicle-container');
        this.elements.voiceContainer = document.getElementById('voice-container');
        this.elements.moneyContainer = document.getElementById('money-container');
        this.elements.jobContainer = document.getElementById('job-container');
        this.elements.gangContainer = document.getElementById('gang-container');
        this.elements.weaponContainer = document.getElementById('weapon-container');
        this.elements.streetContainer = document.getElementById('street-container');
        this.elements.compassContainer = document.getElementById('compass-container');
        this.elements.cinematicBars = document.getElementById('cinematic-bars');
        this.elements.settingsMenu = document.getElementById('settings-menu');

        // Status elements
        this.elements.health = document.getElementById('health');
        this.elements.armor = document.getElementById('armor');
        this.elements.stamina = document.getElementById('stamina');
        this.elements.hunger = document.getElementById('hunger');
        this.elements.thirst = document.getElementById('thirst');
        this.elements.stress = document.getElementById('stress');
    },

    // Setup event listeners
    setupEventListeners() {
        // NUI Message listener
        window.addEventListener('message', this.handleMessage.bind(this));

        // Settings menu listeners
        document.getElementById('show-hud').addEventListener('change', this.toggleHUD.bind(this));
        document.getElementById('hud-scale').addEventListener('input', this.updateScale.bind(this));

        // Key bindings (if needed)
        document.addEventListener('keydown', this.handleKeyPress.bind(this));
    },

    // Initialize HUD components
    initializeComponents() {
        this.updateStatus({
            health: 100,
            armor: 100,
            stamina: 100,
            hunger: 100,
            thirst: 100,
            stress: 0
        });
    },

    // Handle NUI Messages
    handleMessage(event) {
        const data = event.data;

        switch (data.type) {
            case 'status':
                this.updateStatus(data.data);
                break;
            case 'vehicle':
                this.updateVehicle(data.data);
                break;
            case 'voice':
                this.updateVoice(data.data);
                break;
            case 'money':
                this.updateMoney(data.data);
                break;
            case 'job':
                this.updateJob(data.data);
                break;
            case 'gang':
                this.updateGang(data.data);
                break;
            case 'weapon':
                this.updateWeapon(data.data);
                break;
            case 'street':
                this.updateStreet(data.data);
                break;
            case 'compass':
                this.updateCompass(data.data);
                break;
            case 'cinematic':
                this.toggleCinematicMode(data.enabled);
                break;
            case 'settings':
                this.updateSettings(data.data);
                break;
        }
    },

    // Update status elements
    updateStatus(data) {
        this.updateProgressBar(this.elements.health, data.health);
        this.updateProgressBar(this.elements.armor, data.armor);
        this.updateProgressBar(this.elements.stamina, data.stamina);
        this.updateProgressBar(this.elements.hunger, data.hunger);
        this.updateProgressBar(this.elements.thirst, data.thirst);
        this.updateProgressBar(this.elements.stress, data.stress);

        // Add warning classes for low values
        this.elements.health.classList.toggle('health-warning', data.health < 25);
        this.elements.hunger.classList.toggle('critical', data.hunger < 15);
        this.elements.thirst.classList.toggle('critical', data.thirst < 15);
    },

    // Update vehicle HUD
    updateVehicle(data) {
        if (data.isInVehicle !== this.status.vehicle) {
            this.elements.vehicleContainer.classList.toggle('hidden', !data.isInVehicle);
            this.status.vehicle = data.isInVehicle;
        }

        if (data.isInVehicle) {
            document.querySelector('#speed .value').textContent = Math.round(data.speed);
            this.updateProgressBar(document.getElementById('fuel'), data.fuel);
            this.updateProgressBar(document.getElementById('damage'), data.health);

            document.getElementById('fuel').classList.toggle('low', data.fuel < 20);
            document.getElementById('damage').classList.toggle('critical', data.health < 30);
        }
    },

    // Update voice chat
    updateVoice(data) {
        const voiceIndicator = document.querySelector('.voice-indicator');
        document.querySelector('#voice .range').textContent = data.range;
        
        voiceIndicator.className = 'voice-indicator ' + data.range.toLowerCase();
        if (data.isTalking) {
            voiceIndicator.classList.add('speaking');
        } else {
            voiceIndicator.classList.remove('speaking');
        }
    },

    // Update money display
    updateMoney(data) {
        const formatMoney = (amount) => new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD'
        }).format(amount);

        const updateMoneyElement = (elementId, newAmount, oldAmount) => {
            const element = document.querySelector(`#${elementId} .value`);
            element.textContent = formatMoney(newAmount);
            
            if (oldAmount !== undefined) {
                element.classList.remove('increase', 'decrease');
                if (newAmount > oldAmount) {
                    element.classList.add('increase');
                } else if (newAmount < oldAmount) {
                    element.classList.add('decrease');
                }
            }
        };

        updateMoneyElement('cash', data.cash, data.oldCash);
        updateMoneyElement('bank', data.bank, data.oldBank);
    },

    // Update job information
    updateJob(data) {
        document.querySelector('.job-name').textContent = data.name;
        document.querySelector('.job-grade').textContent = data.grade;
        document.querySelector('.duty-status').textContent = data.onDuty ? 'On Duty' : 'Off Duty';
        document.querySelector('.duty-status').classList.toggle('on', data.onDuty);
        document.querySelector('.duty-status').classList.toggle('off', !data.onDuty);
    },

    // Update gang information
    updateGang(data) {
        const hasGang = data.name !== 'None';
        this.elements.gangContainer.classList.toggle('hidden', !hasGang);
        
        if (hasGang) {
            document.querySelector('.gang-name').textContent = data.name;
            document.querySelector('.gang-rank').textContent = data.rank;
        }
    },

    // Update weapon information
    updateWeapon(data) {
        const hasWeapon = data.name !== 'Unarmed';
        this.elements.weaponContainer.classList.toggle('hidden', !hasWeapon);

        if (hasWeapon) {
            document.querySelector('.weapon-name').textContent = data.name;
            document.querySelector('.ammo').textContent = `${data.ammo}/${data.maxAmmo}`;
            document.querySelector('.weapon-item').classList.toggle('low-ammo', data.ammo < (data.maxAmmo * 0.2));
        }
    },

    // Update street name
    updateStreet(data) {
        document.querySelector('.street-name').textContent = data.street;
        document.querySelector('.zone-name').textContent = data.zone;
    },

    // Update compass
    updateCompass(data) {
        document.querySelector('.compass-bearing').textContent = data.heading;
        document.querySelector('.compass-points').style.transform = `translateX(${-data.heading}px)`;
    },

    // Toggle cinematic mode
    toggleCinematicMode(enabled) {
        this.status.cinematicMode = enabled;
        this.elements.cinematicBars.classList.toggle('hidden', !enabled);
        if (enabled) {
            this.elements.cinematicBars.classList.add('cinematic-in');
            this.elements.cinematicBars.classList.remove('cinematic-out');
        } else {
            this.elements.cinematicBars.classList.add('cinematic-out');
            this.elements.cinematicBars.classList.remove('cinematic-in');
        }
    },

    // Update progress bar
    updateProgressBar(element, value) {
        const fill = element.querySelector('.progress-fill');
        const valueDisplay = element.querySelector('.value');
        
        fill.style.width = `${value}%`;
        if (valueDisplay) {
            valueDisplay.textContent = Math.round(value);
        }
    },

    // Toggle HUD visibility
    toggleHUD(event) {
        this.status.visible = event.target.checked;
        this.elements.hudWrapper.classList.toggle('hidden', !this.status.visible);
    },

    // Update HUD scale
    updateScale(event) {
        const scale = event.target.value;
        this.elements.hudWrapper.style.transform = `scale(${scale})`;
    },

    // Handle key presses
    handleKeyPress(event) {
        // Add key bindings as needed
    },

    // Apply configuration
    applyConfig() {
        if (!this.config) return;
        
        // Apply any configuration settings
        if (this.config.scale) {
            document.getElementById('hud-scale').value = this.config.scale;
            this.elements.hudWrapper.style.transform = `scale(${this.config.scale})`;
        }

        if (this.config.visible !== undefined) {
            document.getElementById('show-hud').checked = this.config.visible;
            this.toggleHUD({ target: { checked: this.config.visible } });
        }
    }
};

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => SLHud.init());
