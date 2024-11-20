const Charts = {
    // Revenue Trend Chart
    revenueTrend: {
        instance: null,
        create: (data) => {
            const ctx = document.getElementById('revenue-trend').getContext('2d');
            const gradient = ctx.createLinearGradient(0, 0, 0, 400);
            gradient.addColorStop(0, 'rgba(25, 118, 210, 0.4)');
            gradient.addColorStop(1, 'rgba(25, 118, 210, 0)');

            Charts.revenueTrend.instance = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: data.labels,
                    datasets: [{
                        label: 'Revenue',
                        data: data.values,
                        borderColor: Config.charts.colors.primary,
                        backgroundColor: gradient,
                        tension: 0.4,
                        fill: true
                    }]
                },
                options: {
                    ...Config.charts.defaults,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: (value) => Config.format.currency.format(value)
                            }
                        }
                    }
                }
            });
        },
        update: (data) => {
            if (Charts.revenueTrend.instance) {
                Charts.revenueTrend.instance.data.labels = data.labels;
                Charts.revenueTrend.instance.data.datasets[0].data = data.values;
                Charts.revenueTrend.instance.update();
            }
        }
    },

    // Customer Growth Chart
    customerGrowth: {
        instance: null,
        create: (data) => {
            const ctx = document.getElementById('customer-growth').getContext('2d');
            
            Charts.customerGrowth.instance = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: data.labels,
                    datasets: [{
                        label: 'New Customers',
                        data: data.values,
                        backgroundColor: Config.charts.colors.accent,
                        borderRadius: 4
                    }]
                },
                options: {
                    ...Config.charts.defaults,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1
                            }
                        }
                    }
                }
            });
        },
        update: (data) => {
            if (Charts.customerGrowth.instance) {
                Charts.customerGrowth.instance.data.labels = data.labels;
                Charts.customerGrowth.instance.data.datasets[0].data = data.values;
                Charts.customerGrowth.instance.update();
            }
        }
    },

    // Financial Overview Chart
    financialOverview: {
        instance: null,
        create: (data) => {
            const ctx = document.getElementById('financial-overview').getContext('2d');
            
            Charts.financialOverview.instance = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: data.labels,
                    datasets: [
                        {
                            label: 'Revenue',
                            data: data.revenue,
                            borderColor: Config.charts.colors.success,
                            backgroundColor: 'transparent',
                            tension: 0.4
                        },
                        {
                            label: 'Expenses',
                            data: data.expenses,
                            borderColor: Config.charts.colors.error,
                            backgroundColor: 'transparent',
                            tension: 0.4
                        },
                        {
                            label: 'Profit',
                            data: data.profit,
                            borderColor: Config.charts.colors.primary,
                            backgroundColor: 'transparent',
                            tension: 0.4
                        }
                    ]
                },
                options: {
                    ...Config.charts.defaults,
                    scales: {
                        y: {
                            ticks: {
                                callback: (value) => Config.format.currency.format(value)
                            }
                        }
                    }
                }
            });
        },
        update: (data) => {
            if (Charts.financialOverview.instance) {
                Charts.financialOverview.instance.data.labels = data.labels;
                Charts.financialOverview.instance.data.datasets[0].data = data.revenue;
                Charts.financialOverview.instance.data.datasets[1].data = data.expenses;
                Charts.financialOverview.instance.data.datasets[2].data = data.profit;
                Charts.financialOverview.instance.update();
            }
        }
    },

    // Employee Performance Chart
    employeePerformance: {
        instance: null,
        create: (data) => {
            const ctx = document.getElementById('employee-performance').getContext('2d');
            
            Charts.employeePerformance.instance = new Chart(ctx, {
                type: 'radar',
                data: {
                    labels: ['Performance', 'Attendance', 'Productivity', 'Satisfaction', 'Goals Met'],
                    datasets: data.employees.map((employee, index) => ({
                        label: employee.name,
                        data: [
                            employee.performance,
                            employee.attendance,
                            employee.productivity,
                            employee.satisfaction,
                            employee.goalsmet
                        ],
                        borderColor: Object.values(Config.charts.colors)[index % 6],
                        backgroundColor: `${Object.values(Config.charts.colors)[index % 6]}33`
                    }))
                },
                options: {
                    ...Config.charts.defaults,
                    scales: {
                        r: {
                            beginAtZero: true,
                            max: 100,
                            ticks: {
                                stepSize: 20
                            }
                        }
                    }
                }
            });
        },
        update: (data) => {
            if (Charts.employeePerformance.instance) {
                Charts.employeePerformance.instance.data.datasets = data.employees.map((employee, index) => ({
                    label: employee.name,
                    data: [
                        employee.performance,
                        employee.attendance,
                        employee.productivity,
                        employee.satisfaction,
                        employee.goalsmet
                    ],
                    borderColor: Object.values(Config.charts.colors)[index % 6],
                    backgroundColor: `${Object.values(Config.charts.colors)[index % 6]}33`
                }));
                Charts.employeePerformance.instance.update();
            }
        }
    },

    // Initialize all charts
    initialize: (data) => {
        Charts.revenueTrend.create(data.revenue);
        Charts.customerGrowth.create(data.customers);
        Charts.financialOverview.create(data.financial);
        Charts.employeePerformance.create(data.employees);
    },

    // Update all charts
    updateAll: (data) => {
        Charts.revenueTrend.update(data.revenue);
        Charts.customerGrowth.update(data.customers);
        Charts.financialOverview.update(data.financial);
        Charts.employeePerformance.update(data.employees);
    }
};
