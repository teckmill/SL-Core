// Global players state
window.players = {};

function updatePlayersList(players) {
    window.players = players;
    const playersList = document.getElementById('players-list');
    
    if (!playersList) return;
    
    playersList.innerHTML = '';
    
    Object.values(players).forEach(player => {
        const playerCard = createPlayerCard(player);
        playersList.appendChild(playerCard);
    });
}

function createPlayerCard(player) {
    const card = document.createElement('div');
    card.className = 'player-card';
    
    card.innerHTML = `
        <div class="player-header">
            <div class="player-name">${player.name}</div>
            <div class="player-id">ID: ${player.id}</div>
        </div>
        <div class="player-info">
            <div class="info-item">
                <span class="info-label">Steam</span>
                <span class="info-value">${player.steam || 'N/A'}</span>
            </div>
            <div class="info-item">
                <span class="info-label">Discord</span>
                <span class="info-value">${player.discord || 'N/A'}</span>
            </div>
            <div class="info-item">
                <span class="info-label">License</span>
                <span class="info-value">${player.license || 'N/A'}</span>
            </div>
        </div>
        <div class="player-actions">
            <button class="btn btn-primary" onclick="viewPlayerDetails('${player.id}')">
                <i class="fas fa-user"></i> View Details
            </button>
            <button class="btn btn-warning" onclick="kickPlayer('${player.id}')">
                <i class="fas fa-boot"></i> Kick
            </button>
            <button class="btn btn-danger" onclick="banPlayer('${player.id}')">
                <i class="fas fa-ban"></i> Ban
            </button>
        </div>
    `;
    
    return card;
}

function viewPlayerDetails(playerId) {
    const player = window.players[playerId];
    if (!player) return;
    
    const content = `
        <h2>Player Details</h2>
        <div class="player-details">
            <div class="details-section">
                <h3>Basic Information</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Name</span>
                        <span class="info-value">${player.name}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">ID</span>
                        <span class="info-value">${player.id}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Steam</span>
                        <span class="info-value">${player.steam || 'N/A'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Discord</span>
                        <span class="info-value">${player.discord || 'N/A'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">License</span>
                        <span class="info-value">${player.license || 'N/A'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">IP</span>
                        <span class="info-value">${player.ip || 'N/A'}</span>
                    </div>
                </div>
            </div>
            
            <div class="details-section">
                <h3>Character Information</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Character Name</span>
                        <span class="info-value">${player.charname || 'N/A'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Job</span>
                        <span class="info-value">${player.job?.label || 'N/A'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Grade</span>
                        <span class="info-value">${player.job?.grade_label || 'N/A'}</span>
                    </div>
                </div>
            </div>
            
            <div class="details-section">
                <h3>Actions</h3>
                <div class="action-buttons">
                    <button class="btn btn-primary" onclick="teleportToPlayer('${player.id}')">
                        <i class="fas fa-map-marker-alt"></i> Teleport To
                    </button>
                    <button class="btn btn-primary" onclick="bringPlayer('${player.id}')">
                        <i class="fas fa-user-plus"></i> Bring
                    </button>
                    <button class="btn btn-warning" onclick="freezePlayer('${player.id}')">
                        <i class="fas fa-snowflake"></i> Freeze
                    </button>
                    <button class="btn btn-warning" onclick="spectatePlayer('${player.id}')">
                        <i class="fas fa-eye"></i> Spectate
                    </button>
                </div>
            </div>
        </div>
    `;
    
    openModal(content, { width: '800px' });
}

// Player actions
function kickPlayer(playerId) {
    const player = window.players[playerId];
    if (!player) return;
    
    const content = `
        <h2>Kick Player</h2>
        <div class="form-group">
            <label for="kick-reason">Reason</label>
            <textarea id="kick-reason" class="form-control" rows="3" placeholder="Enter kick reason..."></textarea>
        </div>
        <div class="form-actions">
            <button class="btn btn-secondary" onclick="closeModal()">Cancel</button>
            <button class="btn btn-warning" onclick="confirmKick('${playerId}')">Kick Player</button>
        </div>
    `;
    
    openModal(content);
}

function confirmKick(playerId) {
    const reason = document.getElementById('kick-reason').value;
    
    sendNUICallback('kickPlayer', {
        playerId: playerId,
        reason: reason
    });
    
    closeModal();
}

function banPlayer(playerId) {
    const player = window.players[playerId];
    if (!player) return;
    
    const content = `
        <h2>Ban Player</h2>
        <div class="form-group">
            <label for="ban-reason">Reason</label>
            <textarea id="ban-reason" class="form-control" rows="3" placeholder="Enter ban reason..."></textarea>
        </div>
        <div class="form-group">
            <label for="ban-duration">Duration</label>
            <select id="ban-duration" class="form-control">
                <option value="1h">1 Hour</option>
                <option value="6h">6 Hours</option>
                <option value="12h">12 Hours</option>
                <option value="1d">1 Day</option>
                <option value="3d">3 Days</option>
                <option value="1w">1 Week</option>
                <option value="2w">2 Weeks</option>
                <option value="1m">1 Month</option>
                <option value="3m">3 Months</option>
                <option value="6m">6 Months</option>
                <option value="1y">1 Year</option>
                <option value="permanent">Permanent</option>
            </select>
        </div>
        <div class="form-actions">
            <button class="btn btn-secondary" onclick="closeModal()">Cancel</button>
            <button class="btn btn-danger" onclick="confirmBan('${playerId}')">Ban Player</button>
        </div>
    `;
    
    openModal(content);
}

function confirmBan(playerId) {
    const reason = document.getElementById('ban-reason').value;
    const duration = document.getElementById('ban-duration').value;
    
    sendNUICallback('banPlayer', {
        playerId: playerId,
        reason: reason,
        duration: duration
    });
    
    closeModal();
}

// Other player actions
function teleportToPlayer(playerId) {
    sendNUICallback('teleportToPlayer', { playerId });
    closeModal();
}

function bringPlayer(playerId) {
    sendNUICallback('bringPlayer', { playerId });
    closeModal();
}

function freezePlayer(playerId) {
    sendNUICallback('freezePlayer', { playerId });
    closeModal();
}

function spectatePlayer(playerId) {
    sendNUICallback('spectatePlayer', { playerId });
    closeModal();
}
