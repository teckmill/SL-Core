let statusBars = {
    health: 100,
    armor: 0,
    hunger: 100,
    thirst: 100,
    stress: 0,
    stamina: 100
};

let isVisible = false;
let isCinematicMode = false;

window.addEventListener('message', function(event) {
    const data = event.data;

    switch (data.action) {
        case 'toggleHud':
            isVisible = data.show;
            document.getElementById('hud-container').style.display = data.show ? 'flex' : 'none';
            break;

        case 'updateStatus':
            if (!isVisible) return;
            updateStatusBar(data.status, data.value);
            break;

        case 'updateVehicle':
            if (!isVisible) return;
            updateVehicleHUD(data);
            break;

        case 'updateVoice':
            if (!isVisible) return;
            updateVoiceHUD(data);
            break;

        case 'updateMoney':
            if (!isVisible) return;
            updateMoneyHUD(data);
            break;

        case 'updateJob':
            if (!isVisible) return;
            updateJobHUD(data);
            break;

        case 'updateGang':
            if (!isVisible) return;
            updateGangHUD(data);
            break;

        case 'updateWeapon':
            if (!isVisible) return;
            updateWeaponHUD(data);
            break;

        case 'updateStreet':
            if (!isVisible) return;
            updateStreetHUD(data);
            break;

        case 'updateCompass':
            if (!isVisible) return;
            updateCompassHUD(data);
            break;

        case 'toggleCinematic':
            isCinematicMode = data.enabled;
            document.getElementById('cinematic-mode').style.display = data.enabled ? 'block' : 'none';
            break;
    }
});

function updateStatusBar(status, value) {
    statusBars[status] = value;
    const element = document.querySelector(`.${status}-fill`);
    if (element) {
        element.style.width = `${value}%`;
        
        // Add warning class for low values
        if (value <= 20) {
            element.classList.add('warning');
        } else {
            element.classList.remove('warning');
        }
    }
}

function updateVehicleHUD(data) {
    const vehicleHud = document.getElementById('vehicle-hud');
    if (data.show) {
        vehicleHud.style.display = 'block';
        document.getElementById('speed').textContent = `${Math.round(data.speed)} MPH`;
        document.getElementById('fuel').textContent = `${Math.round(data.fuel)}%`;
        
        // Update engine health indicator
        const engineHealth = document.getElementById('engine');
        const healthPercent = (data.engineHealth / 1000) * 100;
        engineHealth.textContent = `${Math.round(healthPercent)}%`;
        
        // Change color based on engine health
        if (healthPercent < 30) {
            engineHealth.style.color = '#ff4444';
        } else if (healthPercent < 60) {
            engineHealth.style.color = '#ff9800';
        } else {
            engineHealth.style.color = '#4caf50';
        }
    } else {
        vehicleHud.style.display = 'none';
    }
}

function updateVoiceHUD(data) {
    const voiceIndicator = document.getElementById('voice-indicator');
    voiceIndicator.className = `voice-${data.range}`;
    if (data.isTalking) {
        voiceIndicator.classList.add('talking');
    } else {
        voiceIndicator.classList.remove('talking');
    }
}

function updateMoneyHUD(data) {
    document.getElementById('cash').textContent = `$${data.cash.toLocaleString()}`;
    document.getElementById('bank').textContent = `$${data.bank.toLocaleString()}`;
    
    // Animate money changes
    if (data.cash !== data.oldCash) {
        animateMoneyChange('cash', data.cash - data.oldCash);
    }
    if (data.bank !== data.oldBank) {
        animateMoneyChange('bank', data.bank - data.oldBank);
    }
}

function updateJobHUD(data) {
    const jobElement = document.getElementById('job-info');
    jobElement.innerHTML = `
        <span class="job-name">${data.name}</span>
        <span class="job-grade">${data.grade}</span>
        <span class="duty-status ${data.onDuty ? 'on-duty' : 'off-duty'}">
            ${data.onDuty ? 'On Duty' : 'Off Duty'}
        </span>
    `;
}

function updateGangHUD(data) {
    const gangElement = document.getElementById('gang-info');
    if (data.name) {
        gangElement.innerHTML = `
            <span class="gang-name">${data.name}</span>
            <span class="gang-rank">${data.rank}</span>
        `;
        gangElement.style.display = 'block';
    } else {
        gangElement.style.display = 'none';
    }
}

function updateWeaponHUD(data) {
    const weaponElement = document.getElementById('weapon-info');
    if (data.name !== 'Unarmed') {
        weaponElement.innerHTML = `
            <span class="weapon-name">${data.name}</span>
            <span class="ammo-count">${data.ammo}/${data.maxAmmo}</span>
        `;
        weaponElement.style.display = 'block';
    } else {
        weaponElement.style.display = 'none';
    }
}

function updateStreetHUD(data) {
    document.getElementById('street-name').textContent = data.street;
    document.getElementById('zone-name').textContent = data.zone;
}

function updateCompassHUD(data) {
    const compass = document.getElementById('compass');
    compass.style.transform = `rotate(${-data.heading}deg)`;
}

function animateMoneyChange(type, change) {
    const element = document.createElement('div');
    element.className = `money-change ${change > 0 ? 'positive' : 'negative'}`;
    element.textContent = `${change > 0 ? '+' : ''}${change.toLocaleString()}`;
    
    document.getElementById(`${type}-container`).appendChild(element);
    
    setTimeout(() => {
        element.remove();
    }, 2000);
}

// Initialize HUD in hidden state
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('hud-container').style.display = 'none';
    Object.keys(statusBars).forEach(status => {
        updateStatusBar(status, statusBars[status]);
    });
});
