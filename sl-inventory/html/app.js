let isDragging = false;
let draggedItem = null;
let inventoryOpen = false;
let currentInventory = 'player';
let secondaryInventory = null;

$(document).ready(function() {
    // Initialize inventory
    setupInventory();
    setupEventListeners();
    setupDragAndDrop();
    setupContextMenu();
    setupHotbar();
    
    // Listen for NUI messages from the game
    window.addEventListener('message', function(event) {
        const data = event.data;
        
        switch (data.action) {
            case 'open':
                openInventory(data);
                break;
            case 'close':
                closeInventory();
                break;
            case 'update':
                updateInventory(data);
                break;
            case 'notification':
                showNotification(data);
                break;
            case 'updateWeight':
                updateWeight(data);
                break;
            case 'updateHotbar':
                updateHotbar(data);
                break;
        }
    });
});

function setupInventory() {
    // Create inventory grid
    const playerInventory = $('#player-inventory');
    const secondInventory = $('#secondary-inventory');
    
    // Generate inventory slots
    for (let i = 1; i <= 40; i++) {
        playerInventory.append(createInventorySlot(i));
    }
    
    // Setup hotbar slots
    const hotbar = $('#hotbar');
    for (let i = 1; i <= 5; i++) {
        hotbar.append(createHotbarSlot(i));
    }
}

function createInventorySlot(index) {
    return `
        <div class="inventory-slot" data-slot="${index}">
            <div class="item-stack">
                <img src="" class="item-image" style="display: none;">
                <div class="item-count"></div>
                <div class="item-weight"></div>
            </div>
        </div>
    `;
}

function createHotbarSlot(index) {
    return `
        <div class="hotbar-slot" data-slot="${index}">
            <div class="hotbar-key">${index}</div>
            <div class="item-stack">
                <img src="" class="item-image" style="display: none;">
                <div class="item-count"></div>
            </div>
        </div>
    `;
}

function setupEventListeners() {
    // Close inventory on ESC
    $(document).keyup(function(e) {
        if (Config.ui.closeKeys.includes(e.which) && inventoryOpen) {
            closeInventory();
        }
    });
    
    // Item use on double click
    $('.inventory-slot').on('dblclick', function() {
        const slot = $(this).data('slot');
        useItem(slot);
    });
    
    // Hotbar keybinds
    Object.entries(Config.hotbar.keys).forEach(([slot, key]) => {
        $(document).keyup(function(e) {
            if (e.which === key) {
                useHotbarItem(slot);
            }
        });
    });
}

function setupDragAndDrop() {
    $('.inventory-slot, .hotbar-slot').draggable({
        helper: 'clone',
        appendTo: 'body',
        zIndex: 99999,
        revert: 'invalid',
        start: function(event, ui) {
            isDragging = true;
            draggedItem = $(this);
            $(ui.helper).addClass('item-dragging');
        },
        stop: function() {
            isDragging = false;
            draggedItem = null;
        }
    }).droppable({
        accept: '.inventory-slot, .hotbar-slot',
        drop: function(event, ui) {
            handleItemDrop(draggedItem, $(this));
        }
    });
}

function setupContextMenu() {
    $.contextMenu({
        selector: '.inventory-slot',
        callback: function(key, options) {
            const slot = $(this).data('slot');
            handleContextAction(key, slot);
        },
        items: Config.contextMenuOptions
    });
}

function handleContextAction(action, slot) {
    switch (action) {
        case 'use':
            useItem(slot);
            break;
        case 'give':
            giveItem(slot);
            break;
        case 'drop':
            dropItem(slot);
            break;
        case 'split':
            splitStack(slot);
            break;
        case 'examine':
            examineItem(slot);
            break;
    }
}

function openInventory(data) {
    inventoryOpen = true;
    currentInventory = data.type;
    secondaryInventory = data.secondary;
    
    updateInventory(data);
    $('#inventory-container').fadeIn(200);
    
    if (Config.ui.blur) {
        $.post('https://sl-inventory/screenblur', JSON.stringify({ blur: true }));
    }
    
    if (Config.ui.sounds) {
        playSound('open');
    }
}

function closeInventory() {
    inventoryOpen = false;
    $('#inventory-container').fadeOut(200);
    
    if (Config.ui.blur) {
        $.post('https://sl-inventory/screenblur', JSON.stringify({ blur: false }));
    }
    
    if (Config.ui.sounds) {
        playSound('close');
    }
    
    $.post('https://sl-inventory/close');
}

function updateInventory(data) {
    // Update player inventory
    updateInventorySlots(data.inventory, '#player-inventory');
    
    // Update secondary inventory if exists
    if (data.secondaryInventory) {
        updateInventorySlots(data.secondaryInventory, '#secondary-inventory');
    }
    
    // Update weight
    if (data.weight) {
        updateWeight(data.weight);
    }
}

function updateInventorySlots(items, container) {
    $(container).find('.inventory-slot').each(function() {
        const slot = $(this).data('slot');
        const item = items[slot];
        
        if (item) {
            updateSlot($(this), item);
        } else {
            clearSlot($(this));
        }
    });
}

function updateSlot(slot, item) {
    const image = slot.find('.item-image');
    const count = slot.find('.item-count');
    const weight = slot.find('.item-weight');
    
    image.attr('src', item.image || Config.defaultImages.item).show();
    count.text(item.count > 1 ? item.count : '');
    
    if (Config.ui.showWeight) {
        weight.text(item.weight ? `${item.weight}kg` : '');
    }
    
    slot.attr('data-item', JSON.stringify(item));
}

function clearSlot(slot) {
    slot.find('.item-image').hide().attr('src', '');
    slot.find('.item-count').text('');
    slot.find('.item-weight').text('');
    slot.removeAttr('data-item');
}

function updateWeight(data) {
    const percentage = (data.current / data.max) * 100;
    $('#weight-bar').css('width', `${percentage}%`);
    $('#weight-text').text(`${data.current.toFixed(1)}/${data.max.toFixed(1)}kg`);
}

function handleItemDrop(from, to) {
    const fromSlot = from.data('slot');
    const toSlot = to.data('slot');
    const fromContainer = from.parent().attr('id');
    const toContainer = to.parent().attr('id');
    
    if (fromSlot === toSlot && fromContainer === toContainer) return;
    
    $.post('https://sl-inventory/moveItem', JSON.stringify({
        from: {
            slot: fromSlot,
            inventory: fromContainer
        },
        to: {
            slot: toSlot,
            inventory: toContainer
        }
    }));
    
    if (Config.ui.sounds) {
        playSound('move');
    }
}

function useItem(slot) {
    const item = getItemData(slot);
    if (!item) return;
    
    $.post('https://sl-inventory/useItem', JSON.stringify({
        slot: slot,
        item: item
    }));
    
    if (Config.ui.sounds) {
        playSound('use');
    }
}

function dropItem(slot) {
    const item = getItemData(slot);
    if (!item) return;
    
    $.post('https://sl-inventory/dropItem', JSON.stringify({
        slot: slot,
        item: item
    }));
    
    if (Config.ui.sounds) {
        playSound('drop');
    }
}

function giveItem(slot) {
    const item = getItemData(slot);
    if (!item) return;
    
    $.post('https://sl-inventory/giveItem', JSON.stringify({
        slot: slot,
        item: item
    }));
}

function splitStack(slot) {
    const item = getItemData(slot);
    if (!item || item.count <= 1) return;
    
    // TODO: Implement split stack UI
}

function examineItem(slot) {
    const item = getItemData(slot);
    if (!item) return;
    
    showItemInfo(item);
}

function getItemData(slot) {
    const slotElement = $(`.inventory-slot[data-slot="${slot}"]`);
    const itemData = slotElement.attr('data-item');
    return itemData ? JSON.parse(itemData) : null;
}

function showItemInfo(item) {
    if (!Config.ui.showItemInfo) return;
    
    const info = $('#item-info');
    info.html(`
        <h3>${item.label}</h3>
        <p>${item.description || ''}</p>
        ${item.weight ? `<p>Weight: ${item.weight}kg</p>` : ''}
        ${item.durability ? `<p>Durability: ${item.durability}%</p>` : ''}
    `).show();
}

function showNotification(data) {
    const notification = $(`
        <div class="notification ${data.type}">
            <i class="${Config.notifications.types[data.type].icon}"></i>
            <span>${data.message}</span>
        </div>
    `);
    
    $('#notifications').append(notification);
    
    setTimeout(() => {
        notification.fadeOut(300, function() {
            $(this).remove();
        });
    }, Config.notifications.duration);
}

function playSound(sound) {
    if (!Config.sounds[sound]) return;
    
    const audio = new Audio(`./sounds/${Config.sounds[sound]}.ogg`);
    audio.volume = 0.2;
    audio.play();
}

function updateHotbar(data) {
    Object.entries(data.items).forEach(([slot, item]) => {
        const hotbarSlot = $(`.hotbar-slot[data-slot="${slot}"]`);
        if (item) {
            updateSlot(hotbarSlot, item);
        } else {
            clearSlot(hotbarSlot);
        }
    });
}

function useHotbarItem(slot) {
    const item = getItemData(slot);
    if (!item) return;
    
    $.post('https://sl-inventory/useHotbarItem', JSON.stringify({
        slot: slot,
        item: item
    }));
}
