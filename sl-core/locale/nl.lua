local Translations = {
    error = {
        not_online = 'Speler is niet online',
        wrong_format = 'Onjuist formaat',
        missing_args = 'Niet alle argumenten zijn ingevoerd (x, y, z)',
        missing_args2 = 'Alle argumenten moeten worden ingevuld!',
        no_access = 'Geen toegang tot dit commando',
        company_too_poor = 'Je werkgever is failliet',
        item_not_exist = 'Item bestaat niet',
        too_heavy = 'Inventaris te vol',
        duplicate_license = 'Dubbele Rockstar-licentie gevonden',
        no_valid_license  = 'Geen geldige Rockstar-licentie gevonden',
        not_whitelisted = 'Je staat niet op de whitelist van deze server'
    },
    success = {
        spawned_car = 'Voertuig gespawnd',
        job_paid = 'Je hebt $%{value} ontvangen',
        item_added = '%{value} toegevoegd aan inventaris',
        money_added = '$%{value} toegevoegd aan %{type}',
        money_removed = '$%{value} verwijderd van %{type}'
    },
    info = {
        received_paycheck = 'Je hebt je salaris van $%{value} ontvangen',
        job_info = 'Baan: %{value} | Rang: %{value2} | Dienst: %{value3}',
        gang_info = 'Gang: %{value} | Rang: %{value2}',
        on_duty = 'Je bent nu in dienst!',
        off_duty = 'Je bent nu uit dienst!',
        checking_ban = 'Hallo %s. We controleren of je gebanned bent.',
        join_server = 'Welkom %s op {Server Name}.',
        checking_whitelisted = 'Hallo %s. We controleren je toestemming.',
        exploit_banned = 'Je bent verbannen voor vals spelen. Check onze Discord voor meer informatie: %{discord}',
        exploit_dropped = 'Je bent gekickt voor exploitatie'
    },
    command = {
        tp = 'Teleporteer naar speler of coördinaten (Alleen Admin)',
        car = 'Spawn een voertuig (Alleen Admin)',
        dv = 'Verwijder voertuig (Alleen Admin)',
        givemoney = 'Geef geld aan een speler (Alleen Admin)',
        setjob = 'Stel baan van een speler in (Alleen Admin)',
        setgang = 'Stel gang van een speler in (Alleen Admin)',
        addpermission = 'Geef speler permissies (Alleen God)',
        removepermission = 'Verwijder speler permissies (Alleen God)',
        kill = 'Dood een speler (Alleen Admin)',
        revive = 'Herleef een speler (Alleen Admin)',
        setmodel = 'Stel spelermodel in (Alleen Admin)',
        noclip = 'Schakel Noclip (Alleen Admin)'
    }
}

if GetConvar('sl_locale', 'en') == 'nl' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
