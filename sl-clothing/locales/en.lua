local Translations = {
    info = {
        open_shop = "[E] Clothing Shop",
        open_menu = "[E] Open Menu",
        open_barber = "[E] Barber Shop",
        open_tattoo = "[E] Tattoo Shop"
    },
    menu = {
        clothing_shop = "Clothing Shop",
        barber_shop = "Barber Shop",
        tattoo_shop = "Tattoo Shop",
        save_outfit = "Save Outfit",
        load_outfit = "Load Outfit",
        delete_outfit = "Delete Outfit"
    },
    buttons = {
        save = "Save",
        exit = "Exit",
        cancel = "Cancel",
        rotate = "Rotate",
        outfits = "Outfits"
    },
    notifications = {
        saved = "Outfit saved!",
        loaded = "Outfit loaded!",
        deleted = "Outfit deleted!",
        no_outfit = "No outfit found with this name",
        no_money = "You don't have enough money"
    }
}

Lang = Lang or {}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
