local Translations = {
    error = {
        not_mechanic = 'You are not a mechanic',
        no_vehicle = 'No vehicle nearby',
        not_near_lift = 'You are not near a vehicle lift',
        vehicle_occupied = 'Vehicle is occupied',
        failed_repair = 'Failed to repair vehicle',
        cant_repair = 'Cannot repair this vehicle',
        no_damage = 'Vehicle has no damage',
        no_parts = 'Missing required parts',
        no_tools = 'Missing required tools',
        not_enough_money = 'Not enough money',
        payment_failed = 'Payment failed',
        customer_poor = 'Customer cannot afford repair',
        already_repairing = 'Already repairing a vehicle',
        lift_in_use = 'Vehicle lift is in use',
        no_permission = 'No permission to use this'
    },
    success = {
        vehicle_repaired = 'Vehicle repaired',
        part_replaced = '%s replaced',
        payment_received = 'Received payment: $%s',
        bill_sent = 'Bill sent to customer',
        lift_raised = 'Vehicle lift raised',
        lift_lowered = 'Vehicle lift lowered',
        diagnosis_complete = 'Vehicle diagnosis complete'
    },
    info = {
        repair_shop = 'Repair Shop',
        mechanic_shop = 'Mechanic Shop',
        vehicle_lift = 'Vehicle Lift',
        tool_bench = 'Tool Bench',
        parts_storage = 'Parts Storage',
        diagnostic_unit = 'Diagnostic Unit',
        repair_progress = 'Repair Progress: %s%',
        estimated_cost = 'Estimated Cost: $%s',
        repair_time = 'Estimated Time: %s minutes',
        damage_report = 'Damage Report',
        engine_health = 'Engine Health: %s%',
        body_health = 'Body Health: %s%',
        required_parts = 'Required Parts',
        required_tools = 'Required Tools',
        press_repair = 'Press [E] to repair',
        press_diagnose = 'Press [E] to diagnose',
        press_lift = 'Press [E] to use lift',
        press_cancel = 'Press [X] to cancel'
    },
    menu = {
        header = 'Mechanic Menu',
        close = '⬅ Close Menu',
        repair_options = 'Repair Options',
        full_repair = 'Full Repair',
        engine_repair = 'Engine Repair',
        body_repair = 'Body Repair',
        part_repair = 'Part Repair',
        diagnose = 'Diagnose Vehicle',
        manage_lift = 'Manage Lift',
        billing = 'Customer Billing',
        parts = 'Parts Management'
    },
    parts = {
        engine = 'Engine',
        transmission = 'Transmission',
        brakes = 'Brakes',
        suspension = 'Suspension',
        axle = 'Axle',
        radiator = 'Radiator',
        clutch = 'Clutch',
        exhaust = 'Exhaust',
        body_panel = 'Body Panel',
        windshield = 'Windshield',
        tire = 'Tire'
    }
}

Lang = Lang or {}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
