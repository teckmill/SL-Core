Config = {}

-- General Settings
Config.Debug = false
Config.RefreshInterval = 300000 -- 5 minutes in milliseconds
Config.MaxHistoricalData = 90 -- days of historical data to keep
Config.DefaultCurrency = '$'
Config.DateFormat = '%Y-%m-%d'
Config.TimeFormat = '%H:%M:%S'

-- Analytics Modules
Config.Modules = {
    financial = {
        enabled = true,
        metrics = {
            revenue = true,
            expenses = true,
            profit = true,
            cashFlow = true,
            roi = true,
            margins = true
        },
        periods = {
            daily = true,
            weekly = true,
            monthly = true,
            quarterly = true,
            yearly = true
        }
    },
    inventory = {
        enabled = true,
        metrics = {
            turnover = true,
            stockLevels = true,
            shrinkage = true,
            reorderPoints = true,
            valuation = true
        },
        alerts = {
            lowStock = true,
            overStock = true,
            expiringSoon = true
        }
    },
    employees = {
        enabled = true,
        metrics = {
            performance = true,
            attendance = true,
            productivity = true,
            satisfaction = true,
            retention = true
        },
        tracking = {
            hours = true,
            sales = true,
            tasks = true,
            goals = true
        }
    },
    customers = {
        enabled = true,
        metrics = {
            satisfaction = true,
            retention = true,
            lifetime_value = true,
            acquisition_cost = true
        },
        tracking = {
            visits = true,
            purchases = true,
            feedback = true,
            preferences = true
        }
    },
    operations = {
        enabled = true,
        metrics = {
            efficiency = true,
            quality = true,
            capacity = true,
            utilization = true
        },
        tracking = {
            downtime = true,
            maintenance = true,
            incidents = true,
            compliance = true
        }
    }
}

-- Report Templates
Config.Reports = {
    daily = {
        sales = true,
        transactions = true,
        inventory = true,
        employees = true
    },
    weekly = {
        performance = true,
        trends = true,
        forecasts = true,
        comparisons = true
    },
    monthly = {
        financial = true,
        operations = true,
        employees = true,
        strategic = true
    },
    custom = {
        enabled = true,
        maxMetrics = 10,
        maxPeriod = 365 -- days
    }
}

-- Visualization Settings
Config.Charts = {
    types = {
        line = true,
        bar = true,
        pie = true,
        scatter = true,
        heatmap = true
    },
    colors = {
        primary = '#2196F3',
        secondary = '#4CAF50',
        accent = '#FFC107',
        error = '#F44336',
        info = '#00BCD4'
    },
    animations = true,
    responsive = true
}

-- Alert Settings
Config.Alerts = {
    types = {
        email = true,
        notification = true,
        dashboard = true
    },
    priorities = {
        low = {
            color = '#4CAF50',
            timeout = 5000
        },
        medium = {
            color = '#FFC107',
            timeout = 10000
        },
        high = {
            color = '#F44336',
            timeout = 0 -- No timeout for high priority
        }
    },
    thresholds = {
        inventory = {
            lowStock = 20, -- percentage
            overStock = 150, -- percentage
            expiringSoon = 7 -- days
        },
        financial = {
            profitMargin = 10, -- percentage
            cashFlow = 1000, -- minimum amount
            expenses = 5000 -- alert if above
        },
        employees = {
            attendance = 85, -- percentage
            performance = 70, -- percentage
            satisfaction = 75 -- percentage
        }
    }
}

-- Export Settings
Config.Exports = {
    formats = {
        pdf = true,
        csv = true,
        excel = true,
        json = true
    },
    scheduling = {
        enabled = true,
        frequency = {
            daily = true,
            weekly = true,
            monthly = true,
            custom = true
        }
    },
    retention = {
        reports = 90, -- days
        raw_data = 365 -- days
    }
}

-- Integration Settings
Config.Integrations = {
    banking = true,
    business = true,
    payroll = true,
    inventory = true,
    jobs = true
}

-- UI Settings
Config.UI = {
    theme = {
        mode = 'dark', -- 'dark' or 'light'
        primary = '#1976D2',
        secondary = '#424242',
        accent = '#82B1FF'
    },
    dashboard = {
        layout = 'grid', -- 'grid' or 'list'
        widgets = {
            financial = true,
            inventory = true,
            employees = true,
            customers = true,
            operations = true
        },
        refresh = 300000 -- 5 minutes in milliseconds
    },
    notifications = {
        position = 'top-right',
        duration = 5000,
        sound = true
    }
}

-- Performance Settings
Config.Performance = {
    caching = {
        enabled = true,
        duration = 300, -- seconds
        maxSize = 100 -- MB
    },
    queries = {
        timeout = 10000, -- milliseconds
        maxRows = 10000,
        pagination = {
            enabled = true,
            pageSize = 50
        }
    },
    optimization = {
        compression = true,
        minification = true,
        lazyLoading = true
    }
}

return Config
