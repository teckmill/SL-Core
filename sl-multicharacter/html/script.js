let maxCharacters = 0;
let selectedCharacter = null;

$(document).ready(() => {
    window.addEventListener('message', (event) => {
        const data = event.data;

        switch (data.action) {
            case 'openUI':
                maxCharacters = data.maxCharacters;
                $('.container').show();
                setupCharacterSlots();
                break;

            case 'setupCharacters':
                setupCharacterList(data.characters);
                break;

            case 'closeUI':
                $('.container').hide();
                break;
        }
    });

    // Event Listeners
    $('.back-btn').click(() => {
        $('.character-info, .character-register').hide();
        $('.characters-list').show();
    });

    $('#register-form').submit((e) => {
        e.preventDefault();
        const formData = {
            firstname: $('#firstname').val(),
            lastname: $('#lastname').val(),
            nationality: $('#nationality').val(),
            birthdate: $('#birthdate').val(),
            gender: $('#gender').val(),
            spawn: $('#spawn').val()
        };

        $.post('https://sl-multicharacter/createCharacter', JSON.stringify(formData));
        $('#register-form')[0].reset();
        $('.character-register').hide();
        $('.characters-list').show();
    });
});

function setupCharacterSlots() {
    const container = $('.character-list-container');
    container.empty();

    // Add spawn locations to form
    const spawnSelect = $('#spawn');
    spawnSelect.empty();
    Object.entries(Config.Spawns).forEach(([key, spawn]) => {
        spawnSelect.append(`<option value="${key}">${spawn.label}</option>`);
    });
}

function setupCharacterList(characters) {
    const container = $('.character-list-container');
    container.empty();

    // Add existing characters
    characters.forEach(char => {
        container.append(`
            <div class="character-slot" data-cid="${char.citizenid}">
                <h3>${char.charinfo.firstname} ${char.charinfo.lastname}</h3>
                <p>Job: ${char.job.label}</p>
                <p>Cash: $${char.money.cash}</p>
                <p>Bank: $${char.money.bank}</p>
            </div>
        `);
    });

    // Add empty slots
    const remainingSlots = maxCharacters - characters.length;
    for (let i = 0; i < remainingSlots; i++) {
        container.append(`
            <div class="character-slot empty">
                <button class="create-btn">Create Character</button>
            </div>
        `);
    }

    // Event listeners for character slots
    $('.character-slot').click(function() {
        const cid = $(this).data('cid');
        if (cid) {
            // Show character info
            selectedCharacter = characters.find(char => char.citizenid === cid);
            showCharacterInfo(selectedCharacter);
        } else {
            // Show character creation
            $('.characters-list').hide();
            $('.character-register').show();
        }
    });
}

function showCharacterInfo(char) {
    $('.char-info-content').html(`
        <h3>${char.charinfo.firstname} ${char.charinfo.lastname}</h3>
        <p>Birth Date: ${char.charinfo.birthdate}</p>
        <p>Gender: ${char.charinfo.gender}</p>
        <p>Nationality: ${char.charinfo.nationality}</p>
        <p>Job: ${char.job.label}</p>
        <p>Cash: $${char.money.cash}</p>
        <p>Bank: $${char.money.bank}</p>
    `);

    $('.characters-list').hide();
    $('.character-info').show();

    // Event listeners for character info buttons
    $('.play-btn').off('click').click(() => {
        $.post('https://sl-multicharacter/selectCharacter', JSON.stringify({
            cData: selectedCharacter
        }));
    });

    $('.delete-btn').off('click').click(() => {
        if (confirm('Are you sure you want to delete this character?')) {
            $.post('https://sl-multicharacter/deleteCharacter', JSON.stringify({
                citizenid: selectedCharacter.citizenid
            }));
            $('.character-info').hide();
            $('.characters-list').show();
        }
    });
}

// Close UI when pressing ESC
$(document).keyup((e) => {
    if (e.key === "Escape") {
        $.post('https://sl-multicharacter/closeUI');
        $('.container').hide();
    }
});
