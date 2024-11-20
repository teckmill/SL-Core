local Translations = {
    error = {
        inventory_full = 'Inventory is full',
        item_not_found = 'Item not found',
        not_enough_space = 'Not enough space',
        not_enough_items = 'Not enough items',
        invalid_amount = 'Invalid amount',
        invalid_slot = 'Invalid slot',
        no_access = 'No access to this inventory',
        too_far = 'Too far away',
        cant_carry = 'You cannot carry that much weight',
        duplicate_item = 'Cannot stack these items',
        inventory_closed = 'Inventory is closed',
        no_permission = 'You do not have permission for this',
        cooldown = 'You must wait before doing this again',
        restricted_area = 'You cannot open inventory here',
        already_crafting = 'You are already crafting something',
        missing_ingredients = 'Missing required ingredients',
        skill_required = 'You need more skill to craft this',
        durability_broken = 'This item is broken',
        license_required = 'You need a license for this'
    },
    success = {
        item_used = 'Item used',
        item_dropped = 'Item dropped',
        items_combined = 'Items combined',
        inventory_saved = 'Inventory saved',
        crafting_complete = 'Crafting complete',
        purchase_complete = 'Purchase complete'
    },
    info = {
        inventory_weight = 'Inventory Weight: %{weight}/%{maxWeight}',
        durability = 'Durability: %{value}%',
        press_to_open = 'Press [E] to open',
        press_to_pickup = 'Press [E] to pickup',
        crafting_progress = 'Crafting: %{progress}%',
        shop_browsing = 'Browsing shop...',
        trunk_accessing = 'Accessing trunk...',
        glovebox_accessing = 'Accessing glovebox...'
    },
    commands = {
        clear_inventory = 'Clear player inventory',
        give_item = 'Give item to player',
        remove_item = 'Remove item from player',
        reset_inventory = 'Reset player inventory',
        view_inventory = 'View player inventory'
    },
    progress = {
        crafting = 'Crafting...',
        using = 'Using...',
        combining = 'Combining items...'
    },
    ui = {
        inventory = 'Inventory',
        hotbar = 'Hotbar',
        weight = 'Weight',
        search = 'Search',
        use = 'Use',
        give = 'Give',
        drop = 'Drop',
        combine = 'Combine',
        close = 'Close',
        amount = 'Amount',
        craft = 'Craft',
        categories = {
            all = 'All Items',
            weapons = 'Weapons',
            ammo = 'Ammunition',
            food = 'Food',
            drinks = 'Drinks',
            medical = 'Medical'
        }
    }
}

if GetConvar('qb_locale', 'en') == 'en' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
