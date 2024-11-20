let currentMenuId = null;

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
    }
});

function openMenu(data) {
    if (!data || !data.id) return;
    
    currentMenuId = data.id;
    const container = document.getElementById('menu-container');
    const title = document.getElementById('menu-title');
    const description = document.getElementById('menu-description');
    const items = document.getElementById('menu-items');

    // Set menu title and description
    title.textContent = data.title || '';
    description.textContent = data.description || '';

    // Clear previous items
    items.innerHTML = '';

    // Add menu items
    if (data.items && Array.isArray(data.items)) {
        data.items.forEach(item => {
            const menuItem = createMenuItem(item);
            items.appendChild(menuItem);
        });
    }

    // Show menu
    container.classList.remove('hidden');
}

function createMenuItem(item) {
    const div = document.createElement('div');
    div.className = 'menu-item';
    
    // Add icon if specified
    if (item.icon) {
        const icon = document.createElement('i');
        icon.className = item.icon;
        div.appendChild(icon);
    }

    // Add content
    const content = document.createElement('div');
    content.className = 'menu-item-content';

    const title = document.createElement('div');
    title.className = 'menu-item-title';
    title.textContent = item.title || '';
    content.appendChild(title);

    if (item.description) {
        const description = document.createElement('div');
        description.className = 'menu-item-description';
        description.textContent = item.description;
        content.appendChild(description);
    }

    div.appendChild(content);

    // Add right text if specified
    if (item.right) {
        const right = document.createElement('div');
        right.className = 'menu-item-right';
        right.textContent = item.right;
        div.appendChild(right);
    }

    // Add click handler
    div.addEventListener('click', () => {
        fetch(`https://${GetParentResourceName()}/clickMenuItem`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                id: currentMenuId,
                itemId: item.id
            })
        });

        // Close menu if specified
        if (item.closeOnClick) {
            closeMenu();
        }
    });

    return div;
}

function closeMenu() {
    currentMenuId = null;
    document.getElementById('menu-container').classList.add('hidden');
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
