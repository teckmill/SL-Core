let statusBars = {
    health: 100,
    armor: 0,
    hunger: 100,
    thirst: 100,
    stress: 0,
    stamina: 100
};

window.addEventListener('message', function(event) {
    let data = event.data;

    switch (data.action) {
        case 'updateStatus':
            updateStatusBar(data.status, data.value);
            break;
        case 'toggleHud':
            document.getElementById('hud-container').style.display = data.show ? 'flex' : 'none';
            break;
        case 'updateVehicle':
            updateVehicleHUD(data);
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

// Initialize status bars
document.addEventListener('DOMContentLoaded', function() {
    Object.keys(statusBars).forEach(status => {
        updateStatusBar(status, statusBars[status]);
    });
});
