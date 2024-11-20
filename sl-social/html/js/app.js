let isVisible = false;

// NUI Message Handler
window.addEventListener('message', function(event) {
    const data = event.data;

    switch (data.action) {
        case 'toggle':
            toggleApp(data.show);
            break;
        case 'updateSocial':
            updateSocialFeed(data.posts);
            break;
        case 'updateMessages':
            updateMessages(data.messages);
            break;
        case 'updateDating':
            updateDatingProfiles(data.profiles);
            break;
        case 'updateReputation':
            updateReputation(data.stats);
            break;
    }
});

// Toggle App Visibility
function toggleApp(show) {
    const app = document.getElementById('app');
    isVisible = show;
    app.classList.toggle('hidden', !show);
}

// Navigation
document.querySelectorAll('.nav-item').forEach(item => {
    item.addEventListener('click', () => {
        // Remove active class from all tabs
        document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));

        // Add active class to clicked tab
        item.classList.add('active');
        const tabId = item.getAttribute('data-tab');
        document.getElementById(tabId).classList.add('active');

        // Notify game of tab change
        fetch(`https://${GetParentResourceName()}/tabChanged`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                tab: tabId
            })
        });
    });
});

// Social Media Functions
function updateSocialFeed(posts) {
    const container = document.querySelector('.posts-container');
    container.innerHTML = '';

    posts.forEach(post => {
        const postElement = createPostElement(post);
        container.appendChild(postElement);
    });
}

function createPostElement(post) {
    const div = document.createElement('div');
    div.className = 'post fade-in';
    div.innerHTML = `
        <div class="post-header">
            <img src="${post.avatar}" alt="Avatar" class="avatar">
            <div class="post-info">
                <div class="post-author">${post.author}</div>
                <div class="post-time">${post.time}</div>
            </div>
        </div>
        <div class="post-content">${post.content}</div>
        <div class="post-actions">
            <button class="like-btn" onclick="likePost('${post.id}')">
                <i class="fas fa-heart"></i> ${post.likes}
            </button>
            <button class="comment-btn" onclick="showComments('${post.id}')">
                <i class="fas fa-comment"></i> ${post.comments.length}
            </button>
        </div>
    `;
    return div;
}

// Message Functions
function updateMessages(messages) {
    const container = document.querySelector('.chat-messages');
    container.innerHTML = '';

    messages.forEach(message => {
        const messageElement = createMessageElement(message);
        container.appendChild(messageElement);
    });

    container.scrollTop = container.scrollHeight;
}

function createMessageElement(message) {
    const div = document.createElement('div');
    div.className = `message ${message.isSender ? 'sent' : 'received'} fade-in`;
    div.innerHTML = `
        <div class="message-content">${message.content}</div>
        <div class="message-time">${message.time}</div>
    `;
    return div;
}

// Dating Functions
function updateDatingProfiles(profiles) {
    const container = document.querySelector('.profile-cards');
    container.innerHTML = '';

    if (profiles.length > 0) {
        const profile = profiles[0]; // Show top profile
        const profileElement = createProfileElement(profile);
        container.appendChild(profileElement);
    }
}

function createProfileElement(profile) {
    const div = document.createElement('div');
    div.className = 'profile-card fade-in';
    div.innerHTML = `
        <img src="${profile.photos[0]}" alt="Profile Photo" class="profile-photo">
        <div class="profile-info">
            <h2>${profile.name}, ${profile.age}</h2>
            <p>${profile.bio}</p>
        </div>
    `;
    return div;
}

// Reputation Functions
function updateReputation(stats) {
    const container = document.querySelector('.reputation-stats');
    container.innerHTML = '';

    Object.entries(stats).forEach(([category, value]) => {
        const statElement = createStatElement(category, value);
        container.appendChild(statElement);
    });
}

function createStatElement(category, value) {
    const div = document.createElement('div');
    div.className = 'stat-item fade-in';
    div.innerHTML = `
        <div class="stat-category">${category}</div>
        <div class="stat-bar">
            <div class="stat-fill" style="width: ${value}%"></div>
        </div>
        <div class="stat-value">${value}%</div>
    `;
    return div;
}

// Event Listeners for Actions
document.querySelector('.post-btn').addEventListener('click', () => {
    const content = document.querySelector('.post-form textarea').value;
    if (content.trim()) {
        fetch(`https://${GetParentResourceName()}/createPost`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                content: content
            })
        });
        document.querySelector('.post-form textarea').value = '';
    }
});

document.querySelector('.send-btn').addEventListener('click', () => {
    const content = document.querySelector('.message-input textarea').value;
    if (content.trim()) {
        fetch(`https://${GetParentResourceName()}/sendMessage`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                content: content
            })
        });
        document.querySelector('.message-input textarea').value = '';
    }
});

document.querySelector('.like-btn').addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/likeDatingProfile`, {
        method: 'POST'
    });
});

document.querySelector('.dislike-btn').addEventListener('click', () => {
    fetch(`https://${GetParentResourceName()}/dislikeDatingProfile`, {
        method: 'POST'
    });
});

// Close app on Escape key
document.addEventListener('keyup', (event) => {
    if (event.key === 'Escape' && isVisible) {
        fetch(`https://${GetParentResourceName()}/closeApp`, {
            method: 'POST'
        });
    }
});
