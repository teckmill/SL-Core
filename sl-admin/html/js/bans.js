// Global bans state
window.bans = {};

function updateBansList(bans) {
    window.bans = bans;
    const bansList = document.getElementById('bans-list');
    
    if (!bansList) return;
    
    bansList.innerHTML = '';
    
    Object.values(bans).forEach(ban => {
        const banCard = createBanCard(ban);
        bansList.appendChild(banCard);
    });
}

function createBanCard(ban) {
    const card = document.createElement('div');
    card.className = 'ban-card';
    
    const isExpired = ban.expire && new Date(ban.expire * 1000) < new Date();
    
    card.innerHTML = `
        <div class="ban-header">
            <div class="ban-name">${ban.name}</div>
            <div class="ban-status ${isExpired ? 'status-expired' : 'status-active'}">
                ${isExpired ? 'Expired' : 'Active'}
            </div>
        </div>
        <div class="ban-info">
            <div class="info-item">
                <span class="info-label">Banned By</span>
                <span class="info-value">${ban.bannedby}</span>
            </div>
            <div class="info-item">
                <span class="info-label">Expires</span>
                <span class="info-value">${ban.expire ? formatDate(ban.expire) : 'Never'}</span>
            </div>
            <div class="info-item">
                <span class="info-label">License</span>
                <span class="info-value">${ban.license || 'N/A'}</span>
            </div>
        </div>
        <div class="ban-reason">
            ${ban.reason}
        </div>
        <div class="ban-actions">
            <button class="btn btn-primary" onclick="viewBanDetails('${ban.id}')">
                <i class="fas fa-eye"></i> View Details
            </button>
            ${!isExpired ? `
                <button class="btn btn-warning" onclick="editBan('${ban.id}')">
                    <i class="fas fa-edit"></i> Edit
                </button>
                <button class="btn btn-danger" onclick="revokeBan('${ban.id}')">
                    <i class="fas fa-times"></i> Revoke
                </button>
            ` : ''}
        </div>
    `;
    
    return card;
}

function viewBanDetails(banId) {
    const ban = window.bans[banId];
    if (!ban) return;
    
    const content = `
        <h2>Ban Details</h2>
        <div class="ban-details">
            <div class="details-section">
                <h3>Basic Information</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Name</span>
                        <span class="info-value">${ban.name}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Status</span>
                        <span class="info-value status-${ban.expire && new Date(ban.expire * 1000) < new Date() ? 'expired' : 'active'}">
                            ${ban.expire && new Date(ban.expire * 1000) < new Date() ? 'Expired' : 'Active'}
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Banned By</span>
                        <span class="info-value">${ban.bannedby}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Expires</span>
                        <span class="info-value">${ban.expire ? formatDate(ban.expire) : 'Never'}</span>
                    </div>
                </div>
            </div>
            
            <div class="details-section">
                <h3>Identifiers</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">License</span>
                        <span class="info-value">${ban.license || 'N/A'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Steam</span>
                        <span class="info-value">${ban.steam || 'N/A'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Discord</span>
                        <span class="info-value">${ban.discord || 'N/A'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">IP</span>
                        <span class="info-value">${ban.ip || 'N/A'}</span>
                    </div>
                </div>
            </div>
            
            <div class="details-section">
                <h3>Ban Reason</h3>
                <div class="ban-text">
                    ${ban.reason}
                </div>
            </div>
            
            ${ban.evidence ? `
                <div class="details-section">
                    <h3>Evidence</h3>
                    <div class="evidence-list">
                        ${ban.evidence.map(item => `
                            <div class="evidence-item">
                                ${item.type === 'image' ? `
                                    <img src="${item.url}" alt="Evidence" class="evidence-image">
                                ` : item.type === 'video' ? `
                                    <video src="${item.url}" controls class="evidence-video"></video>
                                ` : `
                                    <div class="evidence-text">${item.content}</div>
                                `}
                                <div class="evidence-caption">${item.caption || ''}</div>
                            </div>
                        `).join('')}
                    </div>
                </div>
            ` : ''}
            
            <div class="details-section">
                <h3>Actions</h3>
                <div class="action-buttons">
                    ${!ban.expire || new Date(ban.expire * 1000) > new Date() ? `
                        <button class="btn btn-warning" onclick="editBan('${ban.id}')">
                            <i class="fas fa-edit"></i> Edit Ban
                        </button>
                        <button class="btn btn-danger" onclick="revokeBan('${ban.id}')">
                            <i class="fas fa-times"></i> Revoke Ban
                        </button>
                    ` : ''}
                </div>
            </div>
        </div>
    `;
    
    openModal(content, { width: '800px' });
}

function editBan(banId) {
    const ban = window.bans[banId];
    if (!ban) return;
    
    const content = `
        <h2>Edit Ban</h2>
        <div class="form-group">
            <label for="ban-reason">Reason</label>
            <textarea id="ban-reason" class="form-control" rows="3">${ban.reason}</textarea>
        </div>
        <div class="form-group">
            <label for="ban-duration">Duration</label>
            <select id="ban-duration" class="form-control">
                <option value="1h" ${ban.expire && getDurationValue(ban.expire) === '1h' ? 'selected' : ''}>1 Hour</option>
                <option value="6h" ${ban.expire && getDurationValue(ban.expire) === '6h' ? 'selected' : ''}>6 Hours</option>
                <option value="12h" ${ban.expire && getDurationValue(ban.expire) === '12h' ? 'selected' : ''}>12 Hours</option>
                <option value="1d" ${ban.expire && getDurationValue(ban.expire) === '1d' ? 'selected' : ''}>1 Day</option>
                <option value="3d" ${ban.expire && getDurationValue(ban.expire) === '3d' ? 'selected' : ''}>3 Days</option>
                <option value="1w" ${ban.expire && getDurationValue(ban.expire) === '1w' ? 'selected' : ''}>1 Week</option>
                <option value="2w" ${ban.expire && getDurationValue(ban.expire) === '2w' ? 'selected' : ''}>2 Weeks</option>
                <option value="1m" ${ban.expire && getDurationValue(ban.expire) === '1m' ? 'selected' : ''}>1 Month</option>
                <option value="3m" ${ban.expire && getDurationValue(ban.expire) === '3m' ? 'selected' : ''}>3 Months</option>
                <option value="6m" ${ban.expire && getDurationValue(ban.expire) === '6m' ? 'selected' : ''}>6 Months</option>
                <option value="1y" ${ban.expire && getDurationValue(ban.expire) === '1y' ? 'selected' : ''}>1 Year</option>
                <option value="permanent" ${!ban.expire ? 'selected' : ''}>Permanent</option>
            </select>
        </div>
        <div class="form-actions">
            <button class="btn btn-secondary" onclick="closeModal()">Cancel</button>
            <button class="btn btn-warning" onclick="confirmEditBan('${ban.id}')">Update Ban</button>
        </div>
    `;
    
    openModal(content);
}

function getDurationValue(expire) {
    const now = Math.floor(Date.now() / 1000);
    const duration = expire - now;
    
    const hours = duration / 3600;
    const days = hours / 24;
    const weeks = days / 7;
    const months = days / 30;
    const years = days / 365;
    
    if (hours <= 1) return '1h';
    if (hours <= 6) return '6h';
    if (hours <= 12) return '12h';
    if (days <= 1) return '1d';
    if (days <= 3) return '3d';
    if (weeks <= 1) return '1w';
    if (weeks <= 2) return '2w';
    if (months <= 1) return '1m';
    if (months <= 3) return '3m';
    if (months <= 6) return '6m';
    if (years <= 1) return '1y';
    return 'permanent';
}

function confirmEditBan(banId) {
    const reason = document.getElementById('ban-reason').value;
    const duration = document.getElementById('ban-duration').value;
    
    sendNUICallback('editBan', {
        banId: banId,
        reason: reason,
        duration: duration
    });
    
    closeModal();
}

function revokeBan(banId) {
    const ban = window.bans[banId];
    if (!ban) return;
    
    const content = `
        <h2>Revoke Ban</h2>
        <div class="form-group">
            <label for="revoke-reason">Revocation Reason</label>
            <textarea id="revoke-reason" class="form-control" rows="3" placeholder="Enter reason for revoking the ban..."></textarea>
        </div>
        <div class="form-actions">
            <button class="btn btn-secondary" onclick="closeModal()">Cancel</button>
            <button class="btn btn-danger" onclick="confirmRevokeBan('${ban.id}')">Revoke Ban</button>
        </div>
    `;
    
    openModal(content);
}

function confirmRevokeBan(banId) {
    const reason = document.getElementById('revoke-reason').value;
    
    sendNUICallback('revokeBan', {
        banId: banId,
        reason: reason
    });
    
    closeModal();
}
