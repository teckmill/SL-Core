window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case 'DRAW_TEXT':
            DrawText(event.data.data);
            break;
        case 'HIDE_TEXT':
            HideText();
            break;
        case 'CHANGE_TEXT':
            ChangeText(event.data.data);
            break;
        case 'SHOW_NOTIFICATION':
            ShowNotification(event.data.data);
            break;
    }
});

function DrawText(data) {
    const container = document.getElementById('drawtext-container');
    const text = document.getElementById('text');
    
    text.innerHTML = data.text;
    container.style.display = 'block';
    
    if (data.position === 'right') {
        container.style.right = '1%';
        container.style.left = 'auto';
    } else if (data.position === 'left') {
        container.style.left = '1%';
        container.style.right = 'auto';
    }
}

function HideText() {
    document.getElementById('drawtext-container').style.display = 'none';
}

function ChangeText(data) {
    const text = document.getElementById('text');
    text.innerHTML = data.text;
}

function ShowNotification(data) {
    const notifications = document.getElementById('notifications');
    const notification = document.createElement('div');
    
    notification.className = `notification ${data.type || 'success'}`;
    notification.innerHTML = data.message;
    
    notifications.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'fadeOut 0.3s ease-in-out';
        setTimeout(() => {
            notifications.removeChild(notification);
        }, 300);
    }, data.duration || 3000);
}

// Close NUI on escape key
document.onkeyup = function(event) {
    if (event.key === 'Escape') {
        fetch(`https://${GetParentResourceName()}/close`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        });
    }
};
