local Translations = {
    error = {
        not_online = 'Spieler ist nicht online',
        wrong_format = 'Falsches Format',
        missing_args = 'Nicht alle Argumente wurden eingegeben (x, y, z)',
        missing_args2 = 'Alle Argumente müssen ausgefüllt werden!',
        no_access = 'Kein Zugriff auf diesen Befehl',
        company_too_poor = 'Dein Arbeitgeber ist pleite',
        item_not_exist = 'Gegenstand existiert nicht',
        too_heavy = 'Inventar zu voll',
        duplicate_license = 'Doppelte Rockstar-Lizenz gefunden',
        no_valid_license  = 'Keine gültige Rockstar-Lizenz gefunden',
        not_whitelisted = 'Du bist nicht auf der Whitelist dieses Servers'
    },
    success = {
        spawned_car = 'Fahrzeug gespawnt',
        job_paid = 'Du hast $%{value} erhalten',
        item_added = '%{value} zum Inventar hinzugefügt',
        money_added = '$%{value} zu %{type} hinzugefügt',
        money_removed = '$%{value} von %{type} entfernt'
    },
    info = {
        received_paycheck = 'Du hast deinen Gehaltsscheck über $%{value} erhalten',
        job_info = 'Beruf: %{value} | Rang: %{value2} | Dienst: %{value3}',
        gang_info = 'Gang: %{value} | Rang: %{value2}',
        on_duty = 'Du bist jetzt im Dienst!',
        off_duty = 'Du bist jetzt außer Dienst!',
        checking_ban = 'Hallo %s. Wir überprüfen, ob du gebannt bist.',
        join_server = 'Willkommen %s auf {Server Name}.',
        checking_whitelisted = 'Hallo %s. Wir überprüfen deine Berechtigung.',
        exploit_banned = 'Du wurdest wegen Cheating gebannt. Weitere Informationen in unserem Discord: %{discord}',
        exploit_dropped = 'Du wurdest wegen Exploitation gekickt'
    },
    command = {
        tp = 'Zu Spieler oder Koordinaten teleportieren (Nur Admin)',
        car = 'Fahrzeug spawnen (Nur Admin)',
        dv = 'Fahrzeug löschen (Nur Admin)',
        givemoney = 'Einem Spieler Geld geben (Nur Admin)',
        setjob = 'Job eines Spielers festlegen (Nur Admin)',
        setgang = 'Gang eines Spielers festlegen (Nur Admin)',
        addpermission = 'Spieler Berechtigungen geben (Nur God)',
        removepermission = 'Spieler Berechtigungen entziehen (Nur God)',
        kill = 'Spieler töten (Nur Admin)',
        revive = 'Spieler wiederbeleben (Nur Admin)',
        setmodel = 'Spielermodell festlegen (Nur Admin)',
        noclip = 'Noclip umschalten (Nur Admin)'
    }
}

if GetConvar('sl_locale', 'en') == 'de' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
