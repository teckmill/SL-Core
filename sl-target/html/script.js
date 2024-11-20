let currentOptions = null;
let isTargeting = false;

window.addEventListener('message', function(event) {
    const action = event.data.action;
    const data = event.data.data;

    switch (action) {
        case 'SHOW_TARGET':
            showTarget(data);
            break;
        case 'HIDE_TARGET':
            hideTarget();
            break;
        case 'SHOW_MENU':
            showMenu(data);
            break;
        case 'HIDE_MENU':
            hideMenu();
            break;
        case 'UPDATE_TARGET_STATUS':
            updateTargetStatus(data);
            break;
    }
});

function showTarget(data) {
    isTargeting = true;
    document.getElementById('target-wrapper').classList.remove('hidden');
    if (data && data.label) {
        document.getElementById('target-label').textContent = data.label;
    }
}

function hideTarget() {
    isTargeting = false;
    document.getElementById('target-wrapper').classList.add('hidden');
    document.getElementById('target-label').textContent = '';
    hideMenu();
}

function showMenu(data) {
    if (!data || !data.options || !data.options.length) return;
    
    currentOptions = data;
    const optionsList = document.getElementById('options-list');
    const contextLabel = document.getElementById('target-context-label');
    
    // Clear previous options
    optionsList.innerHTML = '';
    
    // Set context label
    contextLabel.textContent = data.label || 'Select an Option';
    
    // Add options
    data.options.forEach(option => {
        const div = document.createElement('div');
        div.className = 'option-item';
        
        if (option.icon) {
            const icon = document.createElement('i');
            icon.className = `option-icon ${option.icon}`;
            div.appendChild(icon);
        }
        
        const label = document.createElement('span');
        label.className = 'option-label';
        label.textContent = option.label;
        div.appendChild(label);
        
        div.addEventListener('click', () => {
            fetch(`https://${GetParentResourceName()}/selectOption`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({
                    type: option.type,
                    event: option.event,
                    data: option.data || {}
                })
            });
            
            if (option.closeOnClick !== false) {
                hideMenu();
            }
        });
        
        optionsList.appendChild(div);
    });
    
    document.getElementById('target-options').classList.remove('hidden');
}

function hideMenu() {
    currentOptions = null;
    document.getElementById('target-options').classList.add('hidden');
    document.getElementById('options-list').innerHTML = '';
}

function updateTargetStatus(data) {
    const eye = document.getElementById('target-eye');
    if (data.available) {
        eye.classList.add('available');
        if (data.color) {
            eye.style.filter = `drop-shadow(0 0 2px rgba(${data.color.r}, ${data.color.g}, ${data.color.b}, 0.5))`;
        }
    } else {
        eye.classList.remove('available');
        eye.style.filter = '';
    }
}

// Close button handler
document.getElementById('close-options').addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    });
    hideMenu();
});

// Close on escape key
document.addEventListener('keyup', (event) => {
    if (event.key === 'Escape') {
        fetch(`https://${GetParentResourceName()}/closeMenu`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({})
        });
        hideMenu();
    }
});
