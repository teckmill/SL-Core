local Translations = {
    error = {
        no_vehicles = 'No vehicles found in this garage',
        not_owner = 'You do not own this vehicle',
        vehicle_damaged = 'Vehicle is too damaged to be stored',
        vehicle_occupied = 'Vehicle is occupied',
        garage_full = 'Garage is full',
        vehicle_not_in_garage = 'Vehicle is not in this garage',
        no_money = 'Not enough money',
        no_impound_fee = 'Cannot afford impound fee',
        already_in_garage = 'Vehicle is already in a garage',
        not_near_garage = 'Not near a garage',
        keys_not_found = 'Vehicle keys not found'
    },
    success = {
        vehicle_parked = 'Vehicle parked',
        vehicle_taken = 'Vehicle taken out',
        vehicle_impounded = 'Vehicle impounded - Fee: $%s',
        vehicle_recovered = 'Vehicle recovered from impound'
    },
    info = {
        garage = 'Garage',
        public_garage = 'Public Garage',
        police_garage = 'Police Garage',
        ambulance_garage = 'Ambulance Garage',
        mechanic_garage = 'Mechanic Garage',
        impound_lot = 'Impound Lot',
        parking_meter = 'Parking Meter',
        store_vehicle = 'Store Vehicle',
        take_vehicle = 'Take Vehicle',
        impound_vehicle = 'Impound Vehicle',
        recover_vehicle = 'Recover Vehicle',
        vehicle_info = 'Vehicle Info',
        vehicle_list = 'Vehicle List',
        vehicle_name = 'Name: %s',
        plate = 'Plate: %s',
        fuel = 'Fuel: %s%',
        body = 'Body: %s%',
        engine = 'Engine: %s%',
        impound_fee = 'Impound Fee: $%s',
        parking_fee = 'Parking Fee: $%s/hour',
        no_vehicles_stored = 'No vehicles stored',
        select_garage = 'Select Garage',
        close_menu = 'Close Menu'
    },
    menu = {
        header = 'Garage Menu',
        close = '⬅ Close Menu',
        my_vehicles = 'My Vehicles',
        store_vehicle = 'Store Current Vehicle',
        vehicle_management = 'Vehicle Management',
        impound = 'Impound Lot',
        transfer_vehicle = 'Transfer Vehicle',
        society_vehicles = 'Society Vehicles'
    }
}

Lang = Lang or {}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
