let currentData = null;

window.addEventListener('message', function(event) {
    const action = event.data.action;
    const data = event.data.data;

    switch (action) {
        case 'OPEN_MENU':
            openMenu(data);
            break;
    }
});

function openMenu(data) {
    currentData = data;
    const wrapper = document.getElementById('input-wrapper');
    const title = document.getElementById('input-title');
    const text = document.getElementById('input-text');
    const inputField = document.getElementById('input-field');

    // Set title and text
    title.textContent = data.title || '';
    text.textContent = data.text || '';

    // Clear previous input field
    inputField.innerHTML = '';

    // Create input based on type
    switch (data.type) {
        case 'text':
            const input = document.createElement('input');
            input.type = 'text';
            input.placeholder = data.placeholder || '';
            inputField.appendChild(input);
            break;

        case 'number':
            const numInput = document.createElement('input');
            numInput.type = 'number';
            numInput.placeholder = data.placeholder || '';
            if (data.min !== undefined) numInput.min = data.min;
            if (data.max !== undefined) numInput.max = data.max;
            inputField.appendChild(numInput);
            break;

        case 'select':
            const select = document.createElement('select');
            if (data.options) {
                data.options.forEach(option => {
                    const opt = document.createElement('option');
                    opt.value = option.value;
                    opt.textContent = option.text;
                    select.appendChild(opt);
                });
            }
            inputField.appendChild(select);
            break;

        case 'textarea':
            const textarea = document.createElement('textarea');
            textarea.placeholder = data.placeholder || '';
            inputField.appendChild(textarea);
            break;
    }

    wrapper.classList.remove('hidden');
}

function getInputValue() {
    const inputField = document.getElementById('input-field');
    const input = inputField.firstChild;
    return input ? input.value : null;
}

document.getElementById('submit-button').addEventListener('click', function() {
    const response = getInputValue();
    fetch(`https://${GetParentResourceName()}/submit`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            response: response
        })
    });
    document.getElementById('input-wrapper').classList.add('hidden');
});

document.getElementById('close-button').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    });
    document.getElementById('input-wrapper').classList.add('hidden');
});
