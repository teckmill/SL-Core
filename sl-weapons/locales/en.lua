local Translations = {
    error = {
        weapon_broken = 'This weapon is broken',
        no_weapon = 'You don\'t have a weapon equipped',
        no_ammo = 'Not enough ammo',
        no_money = 'Not enough money',
        cant_repair = 'This weapon cannot be repaired',
        repair_failed = 'Repair failed',
        attachment_incompatible = 'This attachment is not compatible',
        attachment_already = 'Weapon already has this attachment',
        no_attachment = 'Weapon doesn\'t have this attachment'
    },
    success = {
        weapon_repaired = 'Weapon has been repaired',
        attachment_added = 'Attachment has been added',
        attachment_removed = 'Attachment has been removed'
    },
    info = {
        repair_cost = 'Repair Cost: $%{value}',
        durability = 'Durability: %{value}%',
        examining_weapon = 'Examining weapon...',
        repairing_weapon = 'Repairing weapon...',
        adding_attachment = 'Adding attachment...',
        removing_attachment = 'Removing attachment...'
    }
}

if GetConvar('qb_locale', 'en') == 'en' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
