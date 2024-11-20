let currentTab = 'home';

$(document).ready(function() {
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                $("#phone").fadeIn(500);
                initializePhone(event.data.playerData);
                break;
            case "close":
                $("#phone").fadeOut(500);
                break;
            case "newMessage":
                handleNewMessage(event.data.message);
                break;
        }
    });

    // Navigation handling
    $('.nav-item').click(function() {
        const tab = $(this).data('tab');
        switchTab(tab);
    });

    // Close button
    $('.close-btn').click(function() {
        $.post('https://sl-phone/ClosePhone', JSON.stringify({}));
    });
});

function switchTab(tab) {
    $(`.nav-item[data-tab="${currentTab}"]`).removeClass('active');
    $(`.nav-item[data-tab="${tab}"]`).addClass('active');
    $(`#${currentTab}-screen`).hide();
    $(`#${tab}-screen`).show();
    currentTab = tab;
}

function initializePhone(playerData) {
    // Initialize all apps with player data
    initializeContacts(playerData);
    initializeMessages(playerData);
    initializeCalls(playerData);
    initializeBanking(playerData);
}

function handleNewMessage(message) {
    // Add message to messages list
    const messageHtml = `
        <div class="message ${message.sender === 'me' ? 'sent' : 'received'}">
            <div class="message-content">${message.content}</div>
            <div class="message-time">${message.time}</div>
        </div>
    `;
    $('.messages-container').append(messageHtml);
} 