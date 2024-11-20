let selectedLocation = null;
let currentTab = 'last';
let spawnData = null;

// Utility functions
const createElement = (template) => {
    const element = document.createElement('div');
    element.innerHTML = template;
    return element.firstElementChild;
};

const formatDistance = (distance) => {
    return distance > 1000 ? `${(distance / 1000).toFixed(1)}km` : `${Math.round(distance)}m`;
};

// UI functions
const showContainer = () => {
    const container = document.getElementById('spawn-container');
    container.classList.remove('hidden');
    setTimeout(() => container.classList.add('visible'), 100);
};

const hideContainer = () => {
    const container = document.getElementById('spawn-container');
    container.classList.remove('visible');
    setTimeout(() => container.classList.add('hidden'), 300);
};

const switchTab = (tabName) => {
    // Update tab buttons
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.tab === tabName);
    });

    // Update tab content
    document.querySelectorAll('.spawn-tab').forEach(tab => {
        tab.classList.toggle('active', tab.id === `${tabName}-tab`);
    });

    currentTab = tabName;
};

const createLocationCard = (location, type, id) => {
    const template = document.getElementById('location-card-template');
    const card = template.content.cloneNode(true);
    
    // Set location data
    const locationCard = card.querySelector('.location-card');
    locationCard.dataset.type = type;
    locationCard.dataset.id = id;
    
    // Set image and icon
    const img = card.querySelector('.location-image img');
    img.src = `assets/${location.image}`;
    img.alt = location.label;
    
    const icon = card.querySelector('.location-icon');
    icon.className = `location-icon ${location.icon}`;
    
    // Set text content
    card.querySelector('.location-name').textContent = location.label;
    card.querySelector('.location-description').textContent = location.description;
    
    // Add click handler
    locationCard.addEventListener('click', () => selectLocation(type, id, location));
    
    return locationCard;
};

const selectLocation = (type, id, location) => {
    // Remove previous selection
    document.querySelectorAll('.location-card').forEach(card => {
        card.classList.remove('selected');
    });
    
    // Add selection to clicked card
    const card = document.querySelector(`.location-card[data-type="${type}"][data-id="${id}"]`);
    if (card) {
        card.classList.add('selected');
    }
    
    selectedLocation = { type, id, ...location };
    
    // Preview location
    fetch(`https://${GetParentResourceName()}/previewLocation`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ location })
    });
};

const updateWeather = (weather) => {
    const weatherText = document.getElementById('weather-text');
    weatherText.textContent = weather;
};

const updateTime = (time) => {
    const timeText = document.getElementById('time-text');
    timeText.textContent = time;
};

// Event listeners
document.addEventListener('DOMContentLoaded', () => {
    // Tab switching
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.addEventListener('click', () => switchTab(btn.dataset.tab));
    });
    
    // Spawn button
    document.getElementById('spawn-btn').addEventListener('click', () => {
        if (!selectedLocation) return;
        
        fetch(`https://${GetParentResourceName()}/spawnPlayer`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(selectedLocation)
        });
    });
});

// NUI Message handler
window.addEventListener('message', (event) => {
    const data = event.data;
    
    switch (data.action) {
        case 'openSpawnMenu':
            spawnData = data;
            
            // Clear existing locations
            document.getElementById('spawn-locations').innerHTML = '';
            document.getElementById('apartment-locations').innerHTML = '';
            document.getElementById('hotel-locations').innerHTML = '';
            
            // Add spawn locations
            Object.entries(data.locations).forEach(([id, location]) => {
                const card = createLocationCard(location, 'spawn', id);
                document.getElementById('spawn-locations').appendChild(card);
            });
            
            // Add apartment locations
            Object.entries(data.apartments).forEach(([id, location]) => {
                const card = createLocationCard(location, 'apartment', id);
                document.getElementById('apartment-locations').appendChild(card);
            });
            
            // Add hotel locations
            Object.entries(data.hotels).forEach(([id, location]) => {
                const card = createLocationCard(location, 'hotel', id);
                document.getElementById('hotel-locations').appendChild(card);
            });
            
            // Set last location if available
            if (data.lastLocation) {
                document.getElementById('last-location').addEventListener('click', () => {
                    selectLocation('last', 'last', {
                        coords: data.lastLocation,
                        label: 'Last Location',
                        description: 'Continue where you left off'
                    });
                });
            }
            
            // Apply settings
            if (data.settings) {
                if (data.settings.darkMode) {
                    document.body.classList.add('dark-mode');
                }
                if (!data.settings.showLocationImages) {
                    document.querySelectorAll('.location-image').forEach(img => img.style.display = 'none');
                }
                if (!data.settings.showWeather) {
                    document.querySelector('.weather-info').style.display = 'none';
                }
                if (!data.settings.showTime) {
                    document.querySelector('.time-info').style.display = 'none';
                }
            }
            
            showContainer();
            break;
            
        case 'updateWeather':
            updateWeather(data.weather);
            break;
            
        case 'updateTime':
            updateTime(data.time);
            break;
            
        case 'closeSpawnMenu':
            hideContainer();
            break;
    }
});

// Close on escape key
document.addEventListener('keyup', (event) => {
    if (event.key === 'Escape') {
        fetch(`https://${GetParentResourceName()}/closeUI`, {
            method: 'POST'
        });
    }
});
