let currentCategory = 'face';
let currentData = {};

$(document).ready(function() {
    window.addEventListener('message', function(event) {
        const data = event.data;
        
        switch(data.action) {
            case 'open':
                $('#clothing-menu').fadeIn();
                setupMaxValues(data.maxValues);
                break;
            case 'close':
                $('#clothing-menu').fadeOut();
                break;
            case 'updatePrice':
                updatePrice(data.price);
                break;
        }
    });
    
    // Category Buttons
    $('.category-btn').click(function() {
        const category = $(this).data('category');
        switchCategory(category);
    });
    
    // Camera Controls
    $('.cam-btn').click(function() {
        const view = $(this).data('view');
        $.post('https://sl-clothing/switchCamera', JSON.stringify({
            view: view
        }));
    });
    
    // Save Outfit
    $('#save-outfit').click(function() {
        const outfitName = prompt('Enter outfit name:');
        if (outfitName) {
            $.post('https://sl-clothing/save', JSON.stringify({
                outfitName: outfitName,
                outfitData: currentData
            }));
        }
    });
    
    // Exit Menu
    $('#exit-menu').click(function() {
        $.post('https://sl-clothing/close');
    });
    
    // Component Changes
    $(document).on('input', '.component-slider', function() {
        const component = $(this).data('component');
        const value = parseInt($(this).val());
        updateComponent(component, value);
    });
});

function switchCategory(category) {
    currentCategory = category;
    $('.category-btn').removeClass('active');
    $(`.category-btn[data-category="${category}"]`).addClass('active');
    updateCustomizationOptions();
}

function updateComponent(component, value) {
    currentData[component] = value;
    $.post('https://sl-clothing/updateClothing', JSON.stringify({
        clothingData: {
            [component]: {
                componentId: getComponentId(component),
                drawableId: value,
                textureId: currentData[`${component}_texture`] || 0
            }
        }
    }));
}

function setupMaxValues(maxValues) {
    currentData = {};
    for (const [component, max] of Object.entries(maxValues)) {
        currentData[component] = 0;
        currentData[`${component}_texture`] = 0;
    }
    updateCustomizationOptions();
}

function updateCustomizationOptions() {
    const options = getOptionsForCategory(currentCategory);
    $('#customization-options').html(options);
}

function getOptionsForCategory(category) {
    let html = '';
    const components = getComponentsForCategory(category);
    
    components.forEach(component => {
        const max = currentData[`${component}_max`] || 10;
        html += `
            <div class="component-group">
                <label>${formatComponentName(component)}</label>
                <input type="range" class="component-slider" 
                    data-component="${component}"
                    min="0" max="${max}" value="${currentData[component] || 0}">
                <span class="value">${currentData[component] || 0}</span>
            </div>
        `;
    });
    
    return html;
}

function getComponentId(component) {
    const componentMap = {
        'face': 0,
        'mask': 1,
        'hair': 2,
        'torso': 3,
        'legs': 4,
        'bags': 5,
        'shoes': 6,
        'accessories': 7,
        'undershirt': 8,
        'armor': 9,
        'decals': 10,
        'tops': 11
    };
    return componentMap[component] || 0;
}

function formatComponentName(component) {
    return component.split('_')
        .map(word => word.charAt(0).toUpperCase() + word.slice(1))
        .join(' ');
} 