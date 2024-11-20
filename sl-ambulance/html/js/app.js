let currentPatient = null;

$(document).ready(function() {
    window.addEventListener('message', function(event) {
        const data = event.data;
        
        switch(data.action) {
            case 'openEms':
                $('#ems-container').fadeIn();
                if (data.patient) {
                    updatePatientInfo(data.patient);
                }
                break;
            case 'closeEms':
                $('#ems-container').fadeOut();
                break;
            case 'updateVitals':
                updateVitals(data.vitals);
                break;
            case 'updateWounds':
                updateWounds(data.wounds);
                break;
        }
    });
    
    // Treatment Buttons
    $('.treatment-btn').click(function() {
        const treatment = $(this).data('treatment');
        $.post('https://sl-ambulance/treatment', JSON.stringify({
            type: treatment,
            patient: currentPatient
        }));
    });
    
    // Close on ESC
    $(document).keyup(function(e) {
        if (e.key === "Escape") {
            $.post('https://sl-ambulance/close');
        }
    });
});

function updatePatientInfo(patient) {
    currentPatient = patient;
    $('#patient-name').text(patient.name);
    updateVitals(patient.vitals);
    updateWounds(patient.wounds);
}

function updateVitals(vitals) {
    $('#heart-rate').text(vitals.heartRate + ' BPM');
    $('#blood-pressure').text(vitals.bloodPressure);
    $('#temperature').text(vitals.temperature + '°F');
}

function updateWounds(wounds) {
    const container = $('#wounds-container');
    container.empty();
    
    wounds.forEach((wound, index) => {
        container.append(`
            <div class="wound-item">
                <span>${wound.type} - ${wound.treated ? 'Treated' : 'Untreated'}</span>
                ${!wound.treated ? `
                    <button class="btn btn-primary btn-sm" onclick="treatWound(${index})">
                        Treat
                    </button>
                ` : ''}
            </div>
        `);
    });
}

function treatWound(index) {
    $.post('https://sl-ambulance/treatWound', JSON.stringify({
        index: index,
        patient: currentPatient
    }));
} 