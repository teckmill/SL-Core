local Translations = {
    error = {
        not_online = 'Le joueur n\'est pas en ligne',
        wrong_format = 'Format incorrect',
        missing_args = 'Tous les arguments n\'ont pas été saisis (x, y, z)',
        missing_args2 = 'Tous les arguments doivent être remplis!',
        no_access = 'Pas d\'accès à cette commande',
        company_too_poor = 'Votre employeur est en faillite',
        item_not_exist = 'L\'objet n\'existe pas',
        too_heavy = 'Inventaire trop plein',
        duplicate_license = 'Licence Rockstar en double détectée',
        no_valid_license  = 'Aucune licence Rockstar valide trouvée',
        not_whitelisted = 'Vous n\'êtes pas sur la liste blanche de ce serveur'
    },
    success = {
        spawned_car = 'Véhicule généré',
        job_paid = 'Vous avez reçu $%{value}',
        item_added = '%{value} ajouté à l\'inventaire',
        money_added = '$%{value} ajouté à %{type}',
        money_removed = '$%{value} retiré de %{type}'
    },
    info = {
        received_paycheck = 'Vous avez reçu votre salaire de $%{value}',
        job_info = 'Emploi: %{value} | Grade: %{value2} | Service: %{value3}',
        gang_info = 'Gang: %{value} | Grade: %{value2}',
        on_duty = 'Vous êtes maintenant en service!',
        off_duty = 'Vous n\'êtes plus en service!',
        checking_ban = 'Bonjour %s. Nous vérifions si vous êtes banni.',
        join_server = 'Bienvenue %s sur {Server Name}.',
        checking_whitelisted = 'Bonjour %s. Nous vérifions votre autorisation.',
        exploit_banned = 'Vous avez été banni pour triche. Consultez notre Discord pour plus d\'informations: %{discord}',
        exploit_dropped = 'Vous avez été expulsé pour exploitation'
    },
    command = {
        tp = 'Se téléporter à un joueur ou des coordonnées (Admin uniquement)',
        car = 'Générer un véhicule (Admin uniquement)',
        dv = 'Supprimer un véhicule (Admin uniquement)',
        givemoney = 'Donner de l\'argent à un joueur (Admin uniquement)',
        setjob = 'Définir l\'emploi d\'un joueur (Admin uniquement)',
        setgang = 'Définir le gang d\'un joueur (Admin uniquement)',
        addpermission = 'Donner des permissions à un joueur (God uniquement)',
        removepermission = 'Retirer des permissions à un joueur (God uniquement)',
        kill = 'Tuer un joueur (Admin uniquement)',
        revive = 'Réanimer un joueur (Admin uniquement)',
        setmodel = 'Définir le modèle d\'un joueur (Admin uniquement)',
        noclip = 'Activer/Désactiver le Noclip (Admin uniquement)'
    }
}

if GetConvar('sl_locale', 'en') == 'fr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
