const Config = {
    // Chart.js Global Configuration
    charts: {
        defaults: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        color: '#B0B0B0',
                        font: {
                            family: 'Poppins'
                        }
                    }
                },
                tooltip: {
                    mode: 'index',
                    intersect: false,
                    backgroundColor: '#2D2D2D',
                    titleColor: '#FFFFFF',
                    bodyColor: '#B0B0B0',
                    borderColor: 'rgba(255, 255, 255, 0.1)',
                    borderWidth: 1
                }
            },
            scales: {
                x: {
                    grid: {
                        color: 'rgba(255, 255, 255, 0.1)',
                        borderColor: 'rgba(255, 255, 255, 0.1)'
                    },
                    ticks: {
                        color: '#B0B0B0',
                        font: {
                            family: 'Poppins'
                        }
                    }
                },
                y: {
                    grid: {
                        color: 'rgba(255, 255, 255, 0.1)',
                        borderColor: 'rgba(255, 255, 255, 0.1)'
                    },
                    ticks: {
                        color: '#B0B0B0',
                        font: {
                            family: 'Poppins'
                        }
                    }
                }
            }
        },
        colors: {
            primary: '#1976D2',
            secondary: '#424242',
            accent: '#82B1FF',
            success: '#4CAF50',
            error: '#F44336',
            warning: '#FFC107'
        }
    },

    // Format Settings
    format: {
        currency: new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD'
        }),
        number: new Intl.NumberFormat('en-US'),
        percent: new Intl.NumberFormat('en-US', {
            style: 'percent',
            minimumFractionDigits: 1,
            maximumFractionDigits: 1
        }),
        date: new Intl.DateTimeFormat('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric'
        }),
        time: new Intl.DateTimeFormat('en-US', {
            hour: '2-digit',
            minute: '2-digit'
        })
    },

    // Notification Settings
    notifications: {
        duration: 5000,
        position: 'top-right',
        types: {
            success: {
                icon: 'fas fa-check-circle',
                color: '#4CAF50'
            },
            error: {
                icon: 'fas fa-exclamation-circle',
                color: '#F44336'
            },
            warning: {
                icon: 'fas fa-exclamation-triangle',
                color: '#FFC107'
            },
            info: {
                icon: 'fas fa-info-circle',
                color: '#2196F3'
            }
        }
    },

    // Date Range Presets
    dateRanges: {
        daily: {
            label: 'Today',
            getValue: () => {
                const today = new Date();
                return {
                    start: today,
                    end: today
                };
            }
        },
        weekly: {
            label: 'This Week',
            getValue: () => {
                const today = new Date();
                const startOfWeek = new Date(today);
                startOfWeek.setDate(today.getDate() - today.getDay());
                return {
                    start: startOfWeek,
                    end: today
                };
            }
        },
        monthly: {
            label: 'This Month',
            getValue: () => {
                const today = new Date();
                const startOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
                return {
                    start: startOfMonth,
                    end: today
                };
            }
        },
        quarterly: {
            label: 'This Quarter',
            getValue: () => {
                const today = new Date();
                const quarter = Math.floor(today.getMonth() / 3);
                const startOfQuarter = new Date(today.getFullYear(), quarter * 3, 1);
                return {
                    start: startOfQuarter,
                    end: today
                };
            }
        },
        yearly: {
            label: 'This Year',
            getValue: () => {
                const today = new Date();
                const startOfYear = new Date(today.getFullYear(), 0, 1);
                return {
                    start: startOfYear,
                    end: today
                };
            }
        }
    }
};
