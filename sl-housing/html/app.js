let currentProperty = null;
let currentMenu = null;

// Initialize
$(document).ready(() => {
    window.addEventListener('message', (event) => {
        const data = event.data;

        switch (data.action) {
            case 'show':
                showPropertyMenu(data.property);
                break;
            case 'hide':
                hideAllMenus();
                break;
            case 'showFurniture':
                showFurnitureMenu(data.furniture);
                break;
            case 'updateStorage':
                updateStorage(data.inventory, data.storage);
                break;
            case 'updateKeys':
                updateKeyHolders(data.keyHolders);
                break;
            case 'updateSettings':
                updateSettings(data.settings);
                break;
        }
    });

    // Close button handlers
    $('.close-btn').on('click', function() {
        const menu = $(this).closest('.menu-container');
        if (menu.attr('id') === 'property-menu') {
            hideAllMenus();
            $.post('https://sl-housing/close');
        } else {
            hideMenu(menu.attr('id'));
            showMenu('property-menu');
        }
    });

    // Action button handlers
    $('.action-btn').on('click', function() {
        const action = $(this).data('action');
        handleAction(action);
    });

    // Category filter handlers
    $('.category-btn').on('click', function() {
        $('.category-btn').removeClass('active');
        $(this).addClass('active');
        filterFurniture($(this).data('category'));
    });

    // Settings save handler
    $('.save-btn').on('click', saveSettings);

    // Key management handlers
    setupKeyManagement();

    // Inventory slot handlers
    setupInventoryHandlers();
});

// Menu Management
function showPropertyMenu(property) {
    currentProperty = property;
    hideAllMenus();
    updatePropertyInfo(property);
    showMenu('property-menu');
}

function showMenu(menuId) {
    currentMenu = menuId;
    $(`#${menuId}`).removeClass('hidden');
    $('#housing-app').removeClass('hidden');
}

function hideMenu(menuId) {
    $(`#${menuId}`).addClass('hidden');
}

function hideAllMenus() {
    $('.menu-container').addClass('hidden');
    $('#housing-app').addClass('hidden');
    currentMenu = null;
}

// Property Info
function updatePropertyInfo(property) {
    $('.property-name').text(property.label || 'Property');
    $('#property-location').text(property.address || 'Unknown Location');
    $('#property-value').text(`$${property.price?.toLocaleString() || '0'}`);
    $('#property-condition').text(`${property.condition || 100}%`);
}

// Furniture Management
function showFurnitureMenu(furniture) {
    hideMenu('property-menu');
    populateFurnitureGrid(furniture);
    showMenu('furniture-menu');
}

function populateFurnitureGrid(furniture) {
    const grid = $('#furniture-items');
    grid.empty();

    Object.entries(furniture).forEach(([model, item]) => {
        const element = $(`
            <div class="furniture-item" data-model="${model}" data-category="${item.category}">
                <img src="nui://${item.image}" alt="${item.label}">
                <p>${item.label}</p>
                <span class="item-price">$${item.price.toLocaleString()}</span>
            </div>
        `);

        element.on('click', () => selectFurniture(model));
        grid.append(element);
    });
}

function filterFurniture(category) {
    if (category === 'all') {
        $('.furniture-item').show();
    } else {
        $('.furniture-item').each(function() {
            $(this).toggle($(this).data('category') === category);
        });
    }
}

function selectFurniture(model) {
    $.post('https://sl-housing/selectFurniture', JSON.stringify({
        model: model
    }));
    hideMenu('furniture-menu');
}

// Storage Management
function updateStorage(inventory, storage) {
    updateInventoryGrid('#player-inventory', inventory);
    updateInventoryGrid('#property-storage', storage);
}

function updateInventoryGrid(containerId, items) {
    const container = $(containerId);
    container.empty();

    for (let i = 0; i < 25; i++) {
        const item = items[i];
        const slot = $('<div class="inventory-slot"></div>');

        if (item) {
            slot.append(`
                <img src="nui://${item.image}" alt="${item.label}">
                <div class="item-count">${item.count}</div>
            `);
            slot.data('item', item);
        }

        container.append(slot);
    }
}

function setupInventoryHandlers() {
    $('.inventory-slot').on('click', function() {
        const item = $(this).data('item');
        if (item) {
            $.post('https://sl-housing/moveItem', JSON.stringify({
                item: item,
                fromContainer: $(this).parent().attr('id'),
                toContainer: $(this).parent().attr('id') === 'player-inventory' ? 'property-storage' : 'player-inventory'
            }));
        }
    });
}

// Key Management
function updateKeyHolders(keyHolders) {
    const list = $('#key-holder-list');
    list.empty();

    keyHolders.forEach(holder => {
        list.append(`
            <div class="key-holder" data-id="${holder.id}">
                <span>${holder.name}</span>
                <button class="remove-key-btn">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        `);
    });
}

function setupKeyManagement() {
    $('#key-holder-list').on('click', '.remove-key-btn', function() {
        const holderId = $(this).closest('.key-holder').data('id');
        $.post('https://sl-housing/removeKey', JSON.stringify({
            holderId: holderId
        }));
    });

    $('[data-action="give-key"]').on('click', () => {
        $.post('https://sl-housing/showNearbyPlayers');
    });
}

// Settings Management
function updateSettings(settings) {
    $('#setting-name').val(settings.name || '');
    $('#setting-security').val(settings.security || '1');
    $('#setting-lighting').val(settings.lighting || '50');
    $('#setting-autolock').prop('checked', settings.autolock || false);
}

function saveSettings() {
    const settings = {
        name: $('#setting-name').val(),
        security: $('#setting-security').val(),
        lighting: $('#setting-lighting').val(),
        autolock: $('#setting-autolock').is(':checked')
    };

    $.post('https://sl-housing/saveSettings', JSON.stringify(settings));
    showMenu('property-menu');
}

// Action Handler
function handleAction(action) {
    switch (action) {
        case 'furniture':
            $.post('https://sl-housing/requestFurniture');
            break;
        case 'storage':
            $.post('https://sl-housing/requestStorage');
            hideMenu('property-menu');
            showMenu('storage-menu');
            break;
        case 'keys':
            $.post('https://sl-housing/requestKeys');
            hideMenu('property-menu');
            showMenu('key-menu');
            break;
        case 'settings':
            $.post('https://sl-housing/requestSettings');
            hideMenu('property-menu');
            showMenu('settings-menu');
            break;
    }
}

// Utility Functions
function formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// Keyboard Events
document.onkeyup = function(event) {
    if (event.key === 'Escape') {
        if (currentMenu === 'property-menu') {
            hideAllMenus();
            $.post('https://sl-housing/close');
        } else if (currentMenu) {
            hideMenu(currentMenu);
            showMenu('property-menu');
        }
    }
};
