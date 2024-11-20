local Translations = {
    error = {
        not_authorized = "You are not authorized to access analytics",
        no_data = "No data available for the selected period",
        invalid_date = "Invalid date range selected",
        export_failed = "Failed to export analytics data",
        query_failed = "Failed to query analytics data",
    },
    success = {
        data_exported = "Analytics data exported successfully",
        report_generated = "Analytics report generated successfully",
    },
    info = {
        generating_report = "Generating analytics report...",
        processing_data = "Processing analytics data...",
        select_date_range = "Select Date Range",
        select_metrics = "Select Metrics",
        loading_data = "Loading data...",
    },
    menu = {
        title = "Server Analytics",
        player_stats = "Player Statistics",
        economy_stats = "Economy Statistics",
        vehicle_stats = "Vehicle Statistics",
        job_stats = "Job Statistics",
        crime_stats = "Crime Statistics",
        export_data = "Export Data",
        refresh_data = "Refresh Data",
        close = "Close",
    },
    metrics = {
        unique_players = "Unique Players",
        peak_players = "Peak Players",
        average_playtime = "Average Playtime",
        new_players = "New Players",
        total_money = "Total Money in Economy",
        money_earned = "Money Earned",
        money_spent = "Money Spent",
        top_earners = "Top Earners",
        vehicles_owned = "Vehicles Owned",
        popular_vehicles = "Most Popular Vehicles",
        vehicle_sales = "Vehicle Sales",
        active_jobs = "Active Jobs",
        job_changes = "Job Changes",
        job_earnings = "Job Earnings",
        crimes_committed = "Crimes Committed",
        arrests_made = "Arrests Made",
        items_stolen = "Items Stolen",
    },
    time = {
        last_24h = "Last 24 Hours",
        last_week = "Last Week",
        last_month = "Last Month",
        custom_range = "Custom Range",
        from = "From",
        to = "To",
    },
    labels = {
        count = "Count",
        amount = "Amount",
        percentage = "Percentage",
        trend = "Trend",
        date = "Date",
        player = "Player",
        vehicle = "Vehicle",
        job = "Job",
        crime = "Crime",
    },
}

if GetConvar('qb_locale', 'en') == 'en' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
