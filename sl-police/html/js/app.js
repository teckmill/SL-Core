let currentTab = 'dashboard';
let mdtData = {};

$(document).ready(function() {
    window.addEventListener('message', function(event) {
        const data = event.data;
        
        switch(data.action) {
            case 'open':
                $('#mdt-container').fadeIn();
                break;
            case 'close':
                $('#mdt-container').fadeOut();
                break;
            case 'updateData':
                mdtData = data.data;
                updateCurrentTab();
                break;
        }
    });
    
    // Tab Switching
    $('.nav-btn').click(function() {
        const tab = $(this).data('tab');
        switchTab(tab);
    });
    
    // Search
    $('#search-btn').click(function() {
        const query = $('#profile-search').val();
        if (query.length > 0) {
            $.post('https://sl-police/searchCitizen', JSON.stringify({
                search: query
            }), function(results) {
                displaySearchResults(results);
            });
        }
    });
    
    // Reports
    $('#new-report').click(function() {
        openNewReportForm();
    });
    
    // Warrants
    $('#new-warrant').click(function() {
        openNewWarrantForm();
    });
    
    // Close MDT
    $(document).keyup(function(e) {
        if (e.key === "Escape") {
            $.post('https://sl-police/close');
        }
    });
});

function switchTab(tab) {
    currentTab = tab;
    $('.nav-btn').removeClass('active');
    $(`.nav-btn[data-tab="${tab}"]`).addClass('active');
    $('.tab-content').removeClass('active');
    $(`#${tab}-tab`).addClass('active');
    updateCurrentTab();
}

function updateCurrentTab() {
    switch(currentTab) {
        case 'dashboard':
            updateDashboard();
            break;
        case 'profiles':
            updateProfiles();
            break;
        case 'reports':
            updateReports();
            break;
        case 'warrants':
            updateWarrants();
            break;
        case 'evidence':
            updateEvidence();
            break;
    }
}

function updateDashboard() {
    // Update recent activity
    let activityHtml = '';
    mdtData.recentActivity?.forEach(activity => {
        activityHtml += `
            <div class="activity-item">
                <span class="time">${formatTime(activity.time)}</span>
                <span class="description">${activity.description}</span>
            </div>
        `;
    });
    $('#activity-feed').html(activityHtml);
    
    // Update active calls
    let callsHtml = '';
    mdtData.activeCalls?.forEach(call => {
        callsHtml += `
            <div class="call-item">
                <span class="type">${call.type}</span>
                <span class="location">${call.location}</span>
                <span class="units">${call.units.join(', ')}</span>
            </div>
        `;
    });
    $('#calls-list').html(callsHtml);
}

function displaySearchResults(results) {
    let html = '';
    results.forEach(result => {
        html += `
            <div class="profile-card">
                <h4>${result.name}</h4>
                <p>ID: ${result.citizenid}</p>
                <button class="btn btn-primary" onclick="viewProfile('${result.citizenid}')">
                    View Profile
                </button>
            </div>
        `;
    });
    $('#search-results').html(html);
}

function formatTime(timestamp) {
    return new Date(timestamp).toLocaleString();
}

// Export for NUI callbacks
window.MDT = {
    updateData: function(data) {
        mdtData = data;
        updateCurrentTab();
    }
}; 