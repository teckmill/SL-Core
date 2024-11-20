// Global reports state
window.reports = {};

function updateReportsList(reports) {
    window.reports = reports;
    const reportsList = document.getElementById('reports-list');
    
    if (!reportsList) return;
    
    reportsList.innerHTML = '';
    
    Object.values(reports).forEach(report => {
        const reportCard = createReportCard(report);
        reportsList.appendChild(reportCard);
    });
}

function createReportCard(report) {
    const card = document.createElement('div');
    card.className = 'report-card';
    
    card.innerHTML = `
        <div class="report-header">
            <div class="report-id">#${report.id}</div>
            <div class="report-status status-${report.status}">${report.status}</div>
        </div>
        <div class="report-info">
            <div class="info-item">
                <span class="info-label">Reported By</span>
                <span class="info-value">${report.reporterName}</span>
            </div>
            <div class="info-item">
                <span class="info-label">Reported Player</span>
                <span class="info-value">${report.targetName}</span>
            </div>
            <div class="info-item">
                <span class="info-label">Time</span>
                <span class="info-value">${formatDate(report.timestamp)}</span>
            </div>
        </div>
        <div class="report-description">
            ${report.reason}
        </div>
        <div class="report-actions">
            <button class="btn btn-primary" onclick="viewReportDetails('${report.id}')">
                <i class="fas fa-eye"></i> View Details
            </button>
            ${report.status === 'pending' ? `
                <button class="btn btn-warning" onclick="assignReport('${report.id}')">
                    <i class="fas fa-user-check"></i> Assign to Me
                </button>
            ` : ''}
            ${report.status === 'in-progress' ? `
                <button class="btn btn-success" onclick="resolveReport('${report.id}')">
                    <i class="fas fa-check"></i> Resolve
                </button>
            ` : ''}
        </div>
    `;
    
    return card;
}

function viewReportDetails(reportId) {
    const report = window.reports[reportId];
    if (!report) return;
    
    const content = `
        <h2>Report Details</h2>
        <div class="report-details">
            <div class="details-section">
                <h3>Basic Information</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Report ID</span>
                        <span class="info-value">#${report.id}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Status</span>
                        <span class="info-value status-${report.status}">${report.status}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Time</span>
                        <span class="info-value">${formatDate(report.timestamp)}</span>
                    </div>
                </div>
            </div>
            
            <div class="details-section">
                <h3>Players Involved</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Reported By</span>
                        <span class="info-value">${report.reporterName}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Reporter ID</span>
                        <span class="info-value">${report.reporterId}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Reported Player</span>
                        <span class="info-value">${report.targetName}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Target ID</span>
                        <span class="info-value">${report.targetId}</span>
                    </div>
                </div>
            </div>
            
            <div class="details-section">
                <h3>Report Description</h3>
                <div class="report-text">
                    ${report.reason}
                </div>
            </div>
            
            ${report.evidence ? `
                <div class="details-section">
                    <h3>Evidence</h3>
                    <div class="evidence-list">
                        ${report.evidence.map(item => `
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
                <h3>Timeline</h3>
                <div class="report-timeline">
                    ${report.timeline.map(event => `
                        <div class="timeline-item">
                            <div class="timeline-icon">
                                <i class="fas ${getTimelineIcon(event.type)}"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="timeline-header">
                                    <span class="timeline-title">${event.title}</span>
                                    <span class="timeline-time">${formatDate(event.timestamp)}</span>
                                </div>
                                <div class="timeline-description">${event.description}</div>
                            </div>
                        </div>
                    `).join('')}
                </div>
            </div>
            
            <div class="details-section">
                <h3>Comments</h3>
                <div class="comments-section">
                    ${report.comments.map(comment => `
                        <div class="comment">
                            <div class="comment-avatar">
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="comment-content">
                                <div class="comment-header">
                                    <span class="comment-author">${comment.author}</span>
                                    <span class="comment-time">${formatDate(comment.timestamp)}</span>
                                </div>
                                <div class="comment-text">${comment.text}</div>
                            </div>
                        </div>
                    `).join('')}
                    
                    <div class="comment-form">
                        <textarea id="comment-text" class="form-control" rows="2" placeholder="Add a comment..."></textarea>
                        <button class="btn btn-primary" onclick="addComment('${report.id}')">
                            <i class="fas fa-paper-plane"></i>
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="details-section">
                <h3>Actions</h3>
                <div class="action-buttons">
                    ${report.status === 'pending' ? `
                        <button class="btn btn-warning" onclick="assignReport('${report.id}')">
                            <i class="fas fa-user-check"></i> Assign to Me
                        </button>
                    ` : ''}
                    ${report.status === 'in-progress' ? `
                        <button class="btn btn-success" onclick="resolveReport('${report.id}')">
                            <i class="fas fa-check"></i> Resolve
                        </button>
                    ` : ''}
                    <button class="btn btn-primary" onclick="teleportToLocation('${report.id}')">
                        <i class="fas fa-map-marker-alt"></i> Teleport to Location
                    </button>
                </div>
            </div>
        </div>
    `;
    
    openModal(content, { width: '800px' });
}

function getTimelineIcon(type) {
    switch (type) {
        case 'created':
            return 'fa-plus-circle';
        case 'assigned':
            return 'fa-user-check';
        case 'comment':
            return 'fa-comment';
        case 'resolved':
            return 'fa-check-circle';
        default:
            return 'fa-circle';
    }
}

function assignReport(reportId) {
    sendNUICallback('assignReport', { reportId });
    closeModal();
}

function resolveReport(reportId) {
    const content = `
        <h2>Resolve Report</h2>
        <div class="form-group">
            <label for="resolution-notes">Resolution Notes</label>
            <textarea id="resolution-notes" class="form-control" rows="3" placeholder="Enter resolution notes..."></textarea>
        </div>
        <div class="form-actions">
            <button class="btn btn-secondary" onclick="closeModal()">Cancel</button>
            <button class="btn btn-success" onclick="confirmResolve('${reportId}')">Resolve Report</button>
        </div>
    `;
    
    openModal(content);
}

function confirmResolve(reportId) {
    const notes = document.getElementById('resolution-notes').value;
    
    sendNUICallback('resolveReport', {
        reportId: reportId,
        notes: notes
    });
    
    closeModal();
}

function addComment(reportId) {
    const text = document.getElementById('comment-text').value;
    if (!text.trim()) return;
    
    sendNUICallback('addReportComment', {
        reportId: reportId,
        text: text
    });
    
    document.getElementById('comment-text').value = '';
}

function teleportToLocation(reportId) {
    sendNUICallback('teleportToReportLocation', { reportId });
    closeModal();
}
