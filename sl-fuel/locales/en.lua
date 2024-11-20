local Translations = {
    error = {
        no_money = 'Not enough money',
        no_fuel = 'No fuel in the station',
        wrong_fuel = 'Wrong fuel type',
        vehicle_full = 'Vehicle is already full',
        no_vehicle = 'You must be in a vehicle',
        not_near_pump = 'You must be near a fuel pump',
        engine_running = 'Turn off the engine first'
    },
    success = {
        refuel_started = 'Started refueling',
        refuel_finished = 'Finished refueling - $%s',
        jerry_can_bought = 'Bought jerry can - $%s',
        jerry_can_refilled = 'Refilled jerry can - $%s'
    },
    info = {
        fuel_station = 'Fuel Station',
        jerry_can = 'Jerry Can',
        fuel_level = 'Fuel Level: %s%',
        refuel_vehicle = 'Refuel Vehicle',
        buy_jerry_can = 'Buy Jerry Can',
        refill_jerry_can = 'Refill Jerry Can',
        hold_refuel = 'Hold [E] to refuel',
        cancel_refuel = 'Cancel refueling',
        close_menu = 'Close Menu',
        current_fuel = 'Current Fuel: %s%',
        fuel_cost = 'Fuel Cost: $%s/L',
        est_cost = 'Estimated Cost: $%s',
        no_fuel_nearby = 'No fuel station nearby'
    },
    menu = {
        fuel_station = 'Fuel Station',
        select_fuel_type = 'Select Fuel Type',
        regular_fuel = 'Regular Fuel',
        premium_fuel = 'Premium Fuel',
        diesel_fuel = 'Diesel Fuel',
        electric = 'Electric Charging',
        close = 'Close'
    }
}

Lang = Lang or {}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
