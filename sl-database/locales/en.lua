local Translations = {
    error = {
        not_connected = "Database connection failed",
        query_failed = "Query execution failed",
        invalid_params = "Invalid parameters provided",
        no_results = "No results found",
        duplicate_entry = "Duplicate entry found",
        transaction_failed = "Transaction failed",
    },
    success = {
        connected = "Database connected successfully",
        query_success = "Query executed successfully",
        transaction_success = "Transaction completed successfully",
    },
    info = {
        connecting = "Connecting to database...",
        executing_query = "Executing query...",
        starting_transaction = "Starting transaction...",
    }
}

CreateThread(function()
    while GetResourceState('sl-core') ~= 'started' do
        Wait(100)
    end
    
    local Core = exports['sl-core']:GetCoreObject()
    if Core.Shared.Locale then
        Core.Shared.Locale('en', Translations)
    end
end)
