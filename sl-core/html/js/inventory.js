let draggedItem = null;
let draggedSlot = null;

$(document).ready(function() {
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                $("#inventory").fadeIn(200);
                setupInventory(event.data.inventory);
                updateWeight(event.data.inventory, event.data.maxweight);
                break;
            case "close":
                $("#inventory").fadeOut(200);
                break;
            case "itemBox":
                itemBox(event.data.item, event.data.type);
                break;
            case "notify":
                notify(event.data.text, event.data.type, event.data.length);
                break;
        }
    });

    $(document).keyup(function(e) {
        if (e.keyCode == 27) { // Escape key
            closeInventory();
        }
    });
});

function setupInventory(items) {
    $("#inventory-grid").empty();
    
    // Create slots
    for (let i = 1; i <= 41; i++) {
        let slot = $(`<div class="inventory-slot" data-slot="${i}"></div>`);
        
        // Add drag and drop events
        slot.on('dragstart', handleDragStart);
        slot.on('dragend', handleDragEnd);
        slot.on('dragover', handleDragOver);
        slot.on('drop', handleDrop);
        
        // Add click event for using items
        slot.on('click', function(e) {
            let slotNum = $(this).data('slot');
            if (items[slotNum]) {
                $.post('https://sl-core/UseItem', JSON.stringify({
                    inventory: 'player',
                    item: items[slotNum]
                }));
            }
        });
        
        $("#inventory-grid").append(slot);
    }
    
    // Fill slots with items
    for (let slot in items) {
        let item = items[slot];
        let slotElement = $(`.inventory-slot[data-slot="${slot}"]`);
        
        slotElement.html(`
            <img src="nui://sl-core/html/images/${item.image}" alt="${item.label}">
            <div class="item-label">${item.label}</div>
            ${item.amount > 1 ? `<div class="item-amount">x${item.amount}</div>` : ''}
        `);
        
        slotElement.attr('draggable', 'true');
    }
}

function updateWeight(items, maxWeight) {
    let currentWeight = 0;
    for (let slot in items) {
        currentWeight += (items[slot].weight * items[slot].amount);
    }
    
    $("#current-weight").text((currentWeight / 1000).toFixed(1));
    $("#max-weight").text((maxWeight / 1000).toFixed(1));
}

function handleDragStart(e) {
    draggedItem = $(this).html();
    draggedSlot = $(this).data('slot');
    $(this).addClass('dragging');
}

function handleDragEnd(e) {
    $(this).removeClass('dragging');
}

function handleDragOver(e) {
    e.preventDefault();
}

function handleDrop(e) {
    e.preventDefault();
    let targetSlot = $(this).data('slot');
    
    if (draggedSlot !== targetSlot) {
        $.post('https://sl-core/MoveItem', JSON.stringify({
            fromSlot: draggedSlot,
            toSlot: targetSlot
        }));
    }
}

function closeInventory() {
    $("#inventory").fadeOut(200);
    $.post('https://sl-core/CloseInventory', JSON.stringify({}));
}

function itemBox(item, type) {
    let $itembox = $("#itembox");
    let $action = $("#itembox-action");
    let $label = $("#itembox-label");
    let $img = $("#itembox-itemimg");
    
    $action.text(type.toUpperCase());
    $label.text(item.label);
    $img.attr('src', `nui://sl-core/html/images/${item.image}`);
    
    $itembox.fadeIn(250);
    setTimeout(() => {
        $itembox.fadeOut(250);
    }, 2500);
}

function notify(message, type, length) {
    let $notification = $(`
        <div class="notification ${type}">
            <span class="material-icons">${getNotificationIcon(type)}</span>
            <span style="margin-left: 10px;">${message}</span>
        </div>
    `);
    
    $("#notifications").append($notification);
    
    setTimeout(() => {
        $notification.css('animation', 'slideOut 0.3s ease-in-out');
        setTimeout(() => {
            $notification.remove();
        }, 300);
    }, length);
}

function getNotificationIcon(type) {
    switch(type) {
        case 'success':
            return 'check_circle';
        case 'error':
            return 'error';
        case 'primary':
            return 'info';
        default:
            return 'info';
    }
}
