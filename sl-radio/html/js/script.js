const radioContainer = document.getElementById('radio-container');
const channelInput = document.getElementById('channel');
const joinButton = document.getElementById('joinChannel');
const leaveButton = document.getElementById('leaveChannel');

// Show/Hide radio UI
window.addEventListener('message', function(event) {
    if (event.data.type === "open") {
        radioContainer.classList.remove('hidden');
        channelInput.focus();
    } else if (event.data.type === "close") {
        radioContainer.classList.add('hidden');
        channelInput.value = '';
    }
});

// Join channel
joinButton.addEventListener('click', function() {
    const channel = channelInput.value;
    if (channel) {
        fetch(`https://${GetParentResourceName()}/joinRadio`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                channel: channel
            })
        });
    }
});

// Leave channel
leaveButton.addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/leaveRadio`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    });
});

// Close on escape
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        fetch(`https://${GetParentResourceName()}/escape`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        });
    }
});
