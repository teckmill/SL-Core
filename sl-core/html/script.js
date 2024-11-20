// Core UI Functions
let SLCore = {};

SLCore.ShowUI = function(data) {
    $('.sl-container').fadeIn(250);
    if (data.header) {
        $('.sl-header h1').text(data.header);
    }
    if (data.content) {
        $('.sl-content').html(data.content);
    }
};

SLCore.HideUI = function() {
    $('.sl-container').fadeOut(250);
};

SLCore.ShowNotification = function(data) {
    const notification = $('.sl-notification');
    notification.text(data.message);
    notification.fadeIn(250);
    
    setTimeout(() => {
        notification.fadeOut(250);
    }, data.duration || 3000);
};

// NUI Message Handler
window.addEventListener('message', function(event) {
    let data = event.data;
    
    switch(data.action) {
        case 'show':
            SLCore.ShowUI(data);
            break;
        case 'hide':
            SLCore.HideUI();
            break;
        case 'notify':
            SLCore.ShowNotification(data);
            break;
    }
});

// Close UI when ESC is pressed
document.onkeyup = function(data) {
    if (data.key == 'Escape') {
        SLCore.HideUI();
        $.post('https://sl-core/close', JSON.stringify({}));
    }
};
