let currentTab = 'employees';
let managementData = {};

$(document).ready(function() {
    // Tab Switching
    $('.nav-link').click(function() {
        const tab = $(this).data('tab');
        switchTab(tab);
    });

    // Close Button
    $('#close-management').click(function() {
        $.post('https://sl-jobs/closeManagement', JSON.stringify({}));
    });

    // Refresh Buttons
    $('#refresh-employees').click(refreshEmployees);
    $('#refresh-applications').click(refreshApplications);

    // Money Management
    $('#deposit-money').click(openDepositDialog);
    $('#withdraw-money').click(openWithdrawDialog);

    // Listen for NUI Messages
    window.addEventListener('message', function(event) {
        const data = event.data;

        switch(data.action) {
            case 'openManagement':
                $('#management-container').removeClass('d-none');
                managementData = data.data;
                updateAllTabs();
                break;
            case 'closeManagement':
                $('#management-container').addClass('d-none');
                break;
            case 'updateData':
                managementData = data.data;
                updateAllTabs();
                break;
        }
    });
});

// Tab Management
function switchTab(tab) {
    $('.nav-link').removeClass('active');
    $(`.nav-link[data-tab="${tab}"]`).addClass('active');
    
    $('.tab-content').removeClass('active');
    $(`#${tab}-tab`).addClass('active');
    
    currentTab = tab;
    updateTabContent(tab);
}

function updateTabContent(tab) {
    switch(tab) {
        case 'employees':
            updateEmployeesList();
            break;
        case 'applications':
            updateApplicationsList();
            break;
        case 'finances':
            updateFinances();
            break;
        case 'settings':
            updateSettings();
            break;
    }
}

// Employee Management
function updateEmployeesList() {
    const employees = managementData.employees || [];
    let html = '';

    employees.forEach(employee => {
        html += `
            <tr>
                <td>${employee.name}</td>
                <td>${employee.grade_label}</td>
                <td>${employee.onduty ? '<span class="badge bg-success">On Duty</span>' : '<span class="badge bg-danger">Off Duty</span>'}</td>
                <td>
                    <button class="btn btn-sm btn-primary" onclick="manageEmployee('${employee.citizenid}')">
                        <i class="fas fa-cog"></i>
                    </button>
                </td>
            </tr>
        `;
    });

    $('#employees-list').html(html);
}

function manageEmployee(citizenid) {
    const employee = managementData.employees.find(e => e.citizenid === citizenid);
    if (!employee) return;

    const html = `
        <div class="modal fade" id="employee-modal">
            <div class="modal-dialog">
                <div class="modal-content bg-dark text-light">
                    <div class="modal-header">
                        <h5 class="modal-title">Manage ${employee.name}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label>Current Grade: ${employee.grade_label}</label>
                            <div class="btn-group w-100">
                                <button class="btn btn-success" onclick="promoteEmployee('${citizenid}')">Promote</button>
                                <button class="btn btn-warning" onclick="demoteEmployee('${citizenid}')">Demote</button>
                            </div>
                        </div>
                        <div class="mb-3">
                            <button class="btn btn-danger w-100" onclick="fireEmployee('${citizenid}')">Fire Employee</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    `;

    $('#employee-modal').remove();
    $('body').append(html);
    new bootstrap.Modal('#employee-modal').show();
}

// Application Management
function updateApplicationsList() {
    const applications = managementData.applications || [];
    let html = '';

    applications.forEach(app => {
        html += `
            <div class="application-card">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h5 class="mb-0">Application from ${app.name}</h5>
                    <span class="badge bg-primary">${app.status}</span>
                </div>
                <p class="mb-2">Applied: ${new Date(app.created_at).toLocaleDateString()}</p>
                <div class="btn-group">
                    <button class="btn btn-success" onclick="reviewApplication('${app.id}', 'accept')">Accept</button>
                    <button class="btn btn-danger" onclick="reviewApplication('${app.id}', 'reject')">Reject</button>
                </div>
            </div>
        `;
    });

    $('#applications-list').html(html || '<p>No pending applications</p>');
}

// Finance Management
function updateFinances() {
    const finances = managementData.finances || { balance: 0, transactions: [] };
    $('#society-balance').text(`$${finances.balance.toLocaleString()}`);

    let html = '';
    finances.transactions.forEach(trans => {
        html += `
            <div class="d-flex justify-content-between align-items-center mb-2">
                <span>${trans.description}</span>
                <span class="${trans.amount > 0 ? 'text-success' : 'text-danger'}">
                    ${trans.amount > 0 ? '+' : ''}$${trans.amount.toLocaleString()}
                </span>
            </div>
        `;
    });

    $('#transactions-list').html(html || '<p>No recent transactions</p>');
}

// Utility Functions
function refreshEmployees() {
    $.post('https://sl-jobs/getEmployees', JSON.stringify({}), function(employees) {
        managementData.employees = employees;
        updateEmployeesList();
    });
}

function refreshApplications() {
    $.post('https://sl-jobs/getApplications', JSON.stringify({}), function(applications) {
        managementData.applications = applications;
        updateApplicationsList();
    });
}

function updateAllTabs() {
    updateEmployeesList();
    updateApplicationsList();
    updateFinances();
    updateSettings();
}

// Export functions for NUI callbacks
window.ManagementUI = {
    updateData: function(data) {
        managementData = data;
        updateAllTabs();
    }
}; 