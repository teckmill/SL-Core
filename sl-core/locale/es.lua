local Translations = {
    error = {
        not_online = 'El jugador no está en línea',
        wrong_format = 'Formato incorrecto',
        missing_args = 'No se han introducido todos los argumentos (x, y, z)',
        missing_args2 = '¡Todos los argumentos deben estar completos!',
        no_access = 'No tienes acceso a este comando',
        company_too_poor = 'Tu empleador está en quiebra',
        item_not_exist = 'El artículo no existe',
        too_heavy = 'Inventario demasiado lleno',
        duplicate_license = 'Se encontró una licencia de Rockstar duplicada',
        no_valid_license  = 'No se encontró una licencia válida de Rockstar',
        not_whitelisted = 'No estás en la lista blanca de este servidor'
    },
    success = {
        spawned_car = 'Vehículo generado',
        job_paid = 'Has recibido $%{value}',
        item_added = '%{value} añadido al inventario',
        money_added = '$%{value} añadido a %{type}',
        money_removed = '$%{value} removido de %{type}'
    },
    info = {
        received_paycheck = 'Has recibido tu pago de $%{value}',
        job_info = 'Trabajo: %{value} | Grado: %{value2} | En servicio: %{value3}',
        gang_info = 'Pandilla: %{value} | Grado: %{value2}',
        on_duty = '¡Ahora estás en servicio!',
        off_duty = '¡Ahora estás fuera de servicio!',
        checking_ban = 'Hola %s. Estamos verificando si estás baneado.',
        join_server = 'Bienvenido %s a {Server Name}.',
        checking_whitelisted = 'Hola %s. Estamos verificando tu permiso.',
        exploit_banned = 'Has sido baneado por hacer trampa. Consulta nuestro Discord para más información: %{discord}',
        exploit_dropped = 'Has sido expulsado por explotación'
    },
    command = {
        tp = 'Teletransportarse a un jugador o coordenadas (Solo Admin)',
        car = 'Generar un vehículo (Solo Admin)',
        dv = 'Eliminar vehículo (Solo Admin)',
        givemoney = 'Dar dinero a un jugador (Solo Admin)',
        setjob = 'Establecer trabajo de un jugador (Solo Admin)',
        setgang = 'Establecer pandilla de un jugador (Solo Admin)',
        addpermission = 'Dar permisos a un jugador (Solo God)',
        removepermission = 'Quitar permisos a un jugador (Solo God)',
        kill = 'Matar a un jugador (Solo Admin)',
        revive = 'Revivir a un jugador (Solo Admin)',
        setmodel = 'Establecer modelo de jugador (Solo Admin)',
        noclip = 'Alternar Noclip (Solo Admin)'
    }
}

if GetConvar('sl_locale', 'en') == 'es' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
