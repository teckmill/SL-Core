-- Analytics Database Schema

-- Business Metrics
CREATE TABLE IF NOT EXISTS business_metrics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    business_id INT NOT NULL,
    metric_type VARCHAR(50) NOT NULL,
    metric_value DECIMAL(15, 2) NOT NULL,
    metric_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    INDEX idx_business_date (business_id, metric_date),
    INDEX idx_metric_type (metric_type)
);

-- Financial Analytics
CREATE TABLE IF NOT EXISTS financial_analytics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    business_id INT NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    revenue DECIMAL(15, 2) DEFAULT 0,
    expenses DECIMAL(15, 2) DEFAULT 0,
    profit DECIMAL(15, 2) DEFAULT 0,
    cash_flow DECIMAL(15, 2) DEFAULT 0,
    roi DECIMAL(10, 4) DEFAULT 0,
    profit_margin DECIMAL(10, 4) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    INDEX idx_business_period (business_id, period_start, period_end)
);

-- Inventory Analytics
CREATE TABLE IF NOT EXISTS inventory_analytics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    business_id INT NOT NULL,
    item_id INT NOT NULL,
    turnover_rate DECIMAL(10, 4) DEFAULT 0,
    stock_level INT DEFAULT 0,
    reorder_point INT DEFAULT 0,
    shrinkage_rate DECIMAL(10, 4) DEFAULT 0,
    valuation DECIMAL(15, 2) DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    INDEX idx_business_item (business_id, item_id)
);

-- Employee Analytics
CREATE TABLE IF NOT EXISTS employee_analytics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    business_id INT NOT NULL,
    employee_id INT NOT NULL,
    performance_score DECIMAL(5, 2) DEFAULT 0,
    attendance_rate DECIMAL(5, 2) DEFAULT 0,
    productivity_rate DECIMAL(5, 2) DEFAULT 0,
    satisfaction_score DECIMAL(5, 2) DEFAULT 0,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    INDEX idx_employee_period (employee_id, period_start, period_end)
);

-- Customer Analytics
CREATE TABLE IF NOT EXISTS customer_analytics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    business_id INT NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    visit_count INT DEFAULT 0,
    purchase_count INT DEFAULT 0,
    total_spent DECIMAL(15, 2) DEFAULT 0,
    satisfaction_score DECIMAL(5, 2) DEFAULT 0,
    last_visit TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    INDEX idx_customer (business_id, customer_id)
);

-- Operational Analytics
CREATE TABLE IF NOT EXISTS operational_analytics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    business_id INT NOT NULL,
    efficiency_rate DECIMAL(5, 2) DEFAULT 0,
    quality_score DECIMAL(5, 2) DEFAULT 0,
    capacity_utilization DECIMAL(5, 2) DEFAULT 0,
    downtime_minutes INT DEFAULT 0,
    incident_count INT DEFAULT 0,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    INDEX idx_business_period (business_id, period_start, period_end)
);

-- Custom Reports
CREATE TABLE IF NOT EXISTS custom_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    business_id INT NOT NULL,
    report_name VARCHAR(100) NOT NULL,
    report_type VARCHAR(50) NOT NULL,
    metrics JSON,
    filters JSON,
    schedule VARCHAR(50),
    last_generated TIMESTAMP,
    created_by VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    INDEX idx_business_type (business_id, report_type)
);

-- Report History
CREATE TABLE IF NOT EXISTS report_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    report_id INT,
    business_id INT NOT NULL,
    report_data JSON,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    generated_by VARCHAR(50) NOT NULL,
    FOREIGN KEY (report_id) REFERENCES custom_reports(id) ON DELETE SET NULL,
    FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    INDEX idx_business_date (business_id, generated_at)
);

-- Analytics Alerts
CREATE TABLE IF NOT EXISTS analytics_alerts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    business_id INT NOT NULL,
    alert_type VARCHAR(50) NOT NULL,
    priority VARCHAR(20) NOT NULL,
    message TEXT NOT NULL,
    metric_value DECIMAL(15, 2),
    threshold_value DECIMAL(15, 2),
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP,
    FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    INDEX idx_business_status (business_id, status)
);

-- Alert History
CREATE TABLE IF NOT EXISTS alert_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    alert_id INT NOT NULL,
    business_id INT NOT NULL,
    action_taken VARCHAR(50) NOT NULL,
    action_by VARCHAR(50) NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (alert_id) REFERENCES analytics_alerts(id) ON DELETE CASCADE,
    FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    INDEX idx_alert (alert_id)
);

-- Data Export Jobs
CREATE TABLE IF NOT EXISTS export_jobs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    business_id INT NOT NULL,
    export_type VARCHAR(50) NOT NULL,
    format VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    parameters JSON,
    file_path VARCHAR(255),
    created_by VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    INDEX idx_business_status (business_id, status)
);
