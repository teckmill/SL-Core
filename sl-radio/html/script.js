let radioChannel = 0;

window.addEventListener('message', function(event) {
    switch(event.data.type) {
        case 'open':
            document.querySelector('.container').classList.add('active');
            document.getElementById('frequency').focus();
            break;
        case 'close':
            document.querySelector('.container').classList.remove('active');
            break;
    }
});

document.getElementById('joinRadio').addEventListener('click', function() {
    const frequency = document.getElementById('frequency').value;
    if (frequency) {
        fetch(`https://${GetParentResourceName()}/joinRadio`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                channel: frequency
            })
        });
    }
});

document.getElementById('leaveRadio').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/leaveRadio`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
});

document.getElementById('volumeUp').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/volumeUp`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
});

document.getElementById('volumeDown').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/volumeDown`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
});

document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        fetch(`https://${GetParentResourceName()}/escape`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        });
        document.querySelector('.container').classList.remove('active');
    }
});
