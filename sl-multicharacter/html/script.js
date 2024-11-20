let maxCharacters = 5;
let characters = [];
let selectedCharacter = null;
let isLoading = false;
let currentCharacterPreview = null;
let previewTimeout = null;

$(document).ready(() => {
    window.addEventListener('message', (event) => {
        const data = event.data;

        switch (data.action) {
            case 'openUI':
                maxCharacters = data.maxCharacters;
                characters = data.characters || [];
                $('.container').fadeIn(300);
                initializeCharacterSlots();
                break;

            case 'closeUI':
                $('.container').fadeOut(300);
                resetUI();
                break;

            case 'refreshCharacters':
                characters = data.characters || [];
                initializeCharacterSlots();
                break;

            case 'showLoading':
                toggleLoading(true);
                break;

            case 'hideLoading':
                toggleLoading(false);
                break;

            case 'error':
                showNotification(data.message, 'error');
                toggleLoading(false);
                break;

            case 'success':
                showNotification(data.message, 'success');
                toggleLoading(false);
                break;
        }
    });

    // Event Listeners
    $('.back-btn').click(() => {
        if (isLoading) return;
        
        $('.character-info, .character-register').fadeOut(300, () => {
            $('.characters-list').fadeIn(300);
        });
        selectedCharacter = null;
        $.post('https://sl-multicharacter/resetCharacter');
    });

    $('#register-form').submit((e) => {
        e.preventDefault();
        if (isLoading) return;

        const formData = {
            firstname: $('#firstname').val().trim(),
            lastname: $('#lastname').val().trim(),
            nationality: $('#nationality').val().trim(),
            birthdate: $('#birthdate').val(),
            gender: $('#gender').val(),
            spawn: $('#spawn').val()
        };

        // Validate form data
        const errors = validateFormData(formData);
        if (errors.length > 0) {
            showNotification(errors[0], 'error');
            return;
        }

        toggleLoading(true);
        $.post('https://sl-multicharacter/createCharacter', JSON.stringify(formData))
            .fail(() => {
                showNotification('Failed to create character. Please try again.', 'error');
                toggleLoading(false);
            });

        $('#register-form')[0].reset();
        $('.character-register').fadeOut(300, () => {
            $('.characters-list').fadeIn(300);
        });
    });

    // Initialize date picker with restrictions
    const today = new Date();
    const minDate = new Date();
    minDate.setFullYear(today.getFullYear() - 80); // Max age 80 years
    const maxDate = new Date();
    maxDate.setFullYear(today.getFullYear() - 18); // Min age 18 years
    
    $('#birthdate').attr({
        'min': minDate.toISOString().split('T')[0],
        'max': maxDate.toISOString().split('T')[0]
    });
});

function validateFormData(data) {
    const errors = [];
    const nameRegex = /^[a-zA-Z\s-]{2,25}$/;

    if (!nameRegex.test(data.firstname)) {
        errors.push('First name must be 2-25 characters long and contain only letters, spaces, or hyphens');
    }
    if (!nameRegex.test(data.lastname)) {
        errors.push('Last name must be 2-25 characters long and contain only letters, spaces, or hyphens');
    }
    if (!nameRegex.test(data.nationality)) {
        errors.push('Nationality must be 2-25 characters long and contain only letters, spaces, or hyphens');
    }
    if (!data.birthdate) {
        errors.push('Please select a valid birth date');
    }
    if (!data.gender) {
        errors.push('Please select a gender');
    }
    if (!data.spawn) {
        errors.push('Please select a spawn location');
    }

    return errors;
}

function initializeCharacterSlots() {
    const container = document.getElementById('characters-list');
    container.innerHTML = '';
    
    for (let i = 0; i < maxCharacters; i++) {
        const slot = document.createElement('div');
        slot.className = 'character-slot';
        slot.setAttribute('data-slot', i);
        
        if (characters[i]) {
            // Character exists in this slot
            const char = characters[i];
            slot.innerHTML = `
                <div class="character-info">
                    <h3>${char.charinfo.firstname} ${char.charinfo.lastname}</h3>
                    <div class="char-details">
                        <p><i class="fas fa-id-card"></i> ${char.citizenid}</p>
                        <p><i class="fas fa-birthday-cake"></i> ${char.charinfo.birthdate}</p>
                        <p><i class="fas fa-venus-mars"></i> ${char.charinfo.gender}</p>
                        <p><i class="fas fa-briefcase"></i> ${char.job.label} - ${char.job.grade}</p>
                        <p><i class="fas fa-wallet"></i> $${char.money.cash.toLocaleString()} / $${char.money.bank.toLocaleString()}</p>
                    </div>
                    <div class="char-actions">
                        <button class="play-btn" onclick="selectCharacter(${i})">
                            <i class="fas fa-play"></i> Play
                        </button>
                        <button class="delete-btn" onclick="deleteCharacter('${char.citizenid}')">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </div>
                </div>
            `;
        } else {
            // Empty slot
            slot.innerHTML = `
                <div class="empty-slot" onclick="createCharacter()">
                    <i class="fas fa-plus-circle"></i>
                    <p>Create New Character</p>
                </div>
            `;
        }
        
        container.appendChild(slot);
    }
}

function showRegistrationForm() {
    document.getElementById('character-list').style.display = 'none';
    document.getElementById('registration-form').style.display = 'block';
}

function selectCharacter(index) {
    const char = characters[index];
    if (!char) return;
    
    $.post('https://sl-multicharacter/selectCharacter', JSON.stringify({
        character: char
    }));
}

function deleteCharacter(citizenid) {
    if (confirm('Are you sure you want to delete this character? This action cannot be undone.')) {
        $.post('https://sl-multicharacter/deleteCharacter', JSON.stringify({
            citizenid: citizenid
        }));
    }
}

function createCharacter() {
    const form = document.getElementById('registration-form');
    form.style.display = 'block';
    document.getElementById('characters-list').style.display = 'none';
}

function toggleLoading(show) {
    isLoading = show;
    if (show) {
        $('.loading-screen').fadeIn(300);
    } else {
        $('.loading-screen').fadeOut(300);
    }
}

function showNotification(message, type = 'info') {
    const icon = type === 'error' ? 'fa-exclamation-circle' : 
                type === 'success' ? 'fa-check-circle' : 
                'fa-info-circle';

    const notification = $(`
        <div class="notification ${type}">
            <i class="fas ${icon}"></i>
            <p>${message}</p>
        </div>
    `).appendTo('body');

    notification.animate({ right: '20px', opacity: 1 }, 300);

    setTimeout(() => {
        notification.animate({ right: '-100%', opacity: 0 }, 300, function() {
            $(this).remove();
        });
    }, 3000);
}

function resetUI() {
    selectedCharacter = null;
    currentCharacterPreview = null;
    clearTimeout(previewTimeout);
    $('.modal').fadeOut(300, function() { $(this).remove(); });
    $('.notification').fadeOut(300, function() { $(this).remove(); });
    $('#register-form')[0].reset();
    $('.character-info, .character-register').hide();
    $('.characters-list').show();
    toggleLoading(false);
}

// Close UI when pressing ESC
$(document).keyup((e) => {
    if (e.key === "Escape") {
        $.post('https://sl-multicharacter/closeUI');
        $('.container').fadeOut(300);
        resetUI();
    }
});
