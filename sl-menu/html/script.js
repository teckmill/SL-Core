let currentMenuId = null;
let currentMenuType = 'list';
let selectedIndex = -1;
let menuItems = [];

window.addEventListener('message', function(event) {
    const action = event.data.action;
    const data = event.data.data;

    switch (action) {
        case 'OPEN_MENU':
            openMenu(data);
            break;
        case 'CLOSE_MENU':
            closeMenu();
            break;
        case 'UPDATE_MENU':
            updateMenu(data);
            break;
        case 'SET_THEME':
            setTheme(event.data.theme);
            break;
    }
});

function openMenu(data) {
    if (!data || !data.id) return;
    
    currentMenuId = data.id;
    currentMenuType = data.type || 'list';
    menuItems = data.items || [];
    selectedIndex = -1;
    
    const container = document.getElementById('menu-container');
    const title = document.getElementById('menu-title');
    const description = document.getElementById('menu-description');
    
    // Set menu title and description
    title.textContent = data.title || '';
    description.textContent = data.description || '';
    
    // Set theme
    setTheme(data.theme || 'default');
    
    // Clear and hide all menu views
    const views = ['menu-items', 'menu-grid', 'menu-context'];
    views.forEach(id => {
        const element = document.getElementById(id);
        element.innerHTML = '';
        element.classList.add('hidden');
    });
    
    // Show appropriate view and render items
    const viewId = `menu-${currentMenuType === 'grid' ? 'grid' : currentMenuType === 'context' ? 'context' : 'items'}`;
    const view = document.getElementById(viewId);
    view.classList.remove('hidden');
    
    renderMenuItems(view);
    
    // Show menu
    container.classList.remove('hidden');
    
    // Focus first non-disabled item
    focusFirstItem();
}

function renderMenuItems(container) {
    menuItems.forEach((item, index) => {
        const div = document.createElement('div');
        div.className = `menu-item${item.disabled ? ' disabled' : ''}`;
        div.setAttribute('data-index', index);
        
        switch (item.type) {
            case 'slider':
                renderSlider(div, item);
                break;
            case 'checkbox':
                renderCheckbox(div, item);
                break;
            case 'input':
                renderInput(div, item);
                break;
            default:
                renderButton(div, item);
        }
        
        if (!item.disabled) {
            div.addEventListener('click', () => handleItemClick(index));
        }
        
        container.appendChild(div);
    });
}

function renderButton(container, item) {
    if (item.icon) {
        const icon = document.createElement('i');
        icon.className = `icon ${item.icon}`;
        container.appendChild(icon);
    }
    
    const label = document.createElement('span');
    label.className = 'label';
    label.textContent = item.label;
    container.appendChild(label);
    
    if (item.value) {
        const value = document.createElement('span');
        value.className = 'value';
        value.textContent = item.value;
        container.appendChild(value);
    }
}

function renderSlider(container, item) {
    const label = document.createElement('span');
    label.className = 'label';
    label.textContent = item.label;
    container.appendChild(label);
    
    const slider = document.createElement('input');
    slider.type = 'range';
    slider.className = 'slider';
    slider.min = item.min || 0;
    slider.max = item.max || 100;
    slider.value = item.value || 0;
    slider.addEventListener('input', (e) => {
        fetch(`https://${GetParentResourceName()}/sliderChange`, {
            method: 'POST',
            body: JSON.stringify({
                id: currentMenuId,
                itemId: item.id,
                value: parseInt(e.target.value)
            })
        });
    });
    container.appendChild(slider);
    
    const value = document.createElement('span');
    value.className = 'value';
    value.textContent = slider.value;
    container.appendChild(value);
}

function renderCheckbox(container, item) {
    const checkbox = document.createElement('div');
    checkbox.className = `checkbox${item.checked ? ' checked' : ''}`;
    container.appendChild(checkbox);
    
    const label = document.createElement('span');
    label.className = 'label';
    label.textContent = item.label;
    container.appendChild(label);
    
    container.addEventListener('click', () => {
        const checked = !checkbox.classList.contains('checked');
        checkbox.classList.toggle('checked');
        fetch(`https://${GetParentResourceName()}/checkboxChange`, {
            method: 'POST',
            body: JSON.stringify({
                id: currentMenuId,
                itemId: item.id,
                checked
            })
        });
    });
}

function renderInput(container, item) {
    const label = document.createElement('span');
    label.className = 'label';
    label.textContent = item.label;
    container.appendChild(label);
    
    const input = document.createElement('input');
    input.type = 'text';
    input.value = item.value || '';
    input.placeholder = item.placeholder || '';
    input.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
            fetch(`https://${GetParentResourceName()}/inputSubmit`, {
                method: 'POST',
                body: JSON.stringify({
                    id: currentMenuId,
                    itemId: item.id,
                    value: input.value
                })
            });
        }
    });
    container.appendChild(input);
}

function handleItemClick(index) {
    const item = menuItems[index];
    if (!item || item.disabled) return;
    
    selectedIndex = index;
    highlightSelectedItem();
    
    if (item.type === 'button') {
        fetch(`https://${GetParentResourceName()}/clickMenuItem`, {
            method: 'POST',
            body: JSON.stringify({
                id: currentMenuId,
                itemId: item.id,
                value: item.value
            })
        });
    }
}

function highlightSelectedItem() {
    const items = document.querySelectorAll('.menu-item');
    items.forEach((item, index) => {
        if (index === selectedIndex) {
            item.classList.add('active');
        } else {
            item.classList.remove('active');
        }
    });
}

function focusFirstItem() {
    const firstNonDisabled = menuItems.findIndex(item => !item.disabled);
    if (firstNonDisabled !== -1) {
        selectedIndex = firstNonDisabled;
        highlightSelectedItem();
    }
}

function closeMenu() {
    const container = document.getElementById('menu-container');
    container.classList.add('hidden');
    currentMenuId = null;
    selectedIndex = -1;
    menuItems = [];
}

function updateMenu(data) {
    if (!currentMenuId || currentMenuId !== data.id) return;
    
    if (data.items) {
        menuItems = data.items;
        const view = document.getElementById(`menu-${currentMenuType === 'grid' ? 'grid' : currentMenuType === 'context' ? 'context' : 'items'}`);
        view.innerHTML = '';
        renderMenuItems(view);
        focusFirstItem();
    }
}

function setTheme(theme) {
    document.querySelector('.menu').setAttribute('data-theme', theme || 'default');
}

// Keyboard Navigation
document.addEventListener('keydown', function(event) {
    if (!currentMenuId) return;
    
    switch (event.key) {
        case 'ArrowUp':
        case 'ArrowLeft':
            navigateMenu(-1);
            event.preventDefault();
            break;
        case 'ArrowDown':
        case 'ArrowRight':
            navigateMenu(1);
            event.preventDefault();
            break;
        case 'Enter':
            if (selectedIndex !== -1) {
                handleItemClick(selectedIndex);
            }
            event.preventDefault();
            break;
        case 'Escape':
            fetch(`https://${GetParentResourceName()}/closeMenu`, {
                method: 'POST',
                body: JSON.stringify({})
            });
            event.preventDefault();
            break;
    }
});

function navigateMenu(direction) {
    if (menuItems.length === 0) return;
    
    let newIndex = selectedIndex;
    do {
        newIndex = (newIndex + direction + menuItems.length) % menuItems.length;
        if (newIndex === selectedIndex) break; // Prevent infinite loop
    } while (menuItems[newIndex].disabled);
    
    if (!menuItems[newIndex].disabled) {
        selectedIndex = newIndex;
        highlightSelectedItem();
        
        // Ensure selected item is visible
        const item = document.querySelector(`.menu-item[data-index="${selectedIndex}"]`);
        if (item) {
            item.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }
    }
}

// Close button handler
document.getElementById('close-menu').addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    });
    closeMenu();
});
