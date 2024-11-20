-- Command Management System
SLCore.Commands = {}
SLCore.Commands.List = {}

-- Register a new command
function SLCore.Commands.Add(name, help, arguments, argsrequired, callback, permission)
    local restricted = true
    if permission == nil or type(permission) ~= "string" then restricted = false end
    
    RegisterCommand(name, function(source, args, rawCommand)
        -- Check if source is console
        if source == 0 then
            if SLCore.Commands.List[name].restricted then
                -- Console has all permissions
                callback(source, args, rawCommand)
            else
                callback(source, args, rawCommand)
            end
            return
        end

        local Player = SLCore.Functions.GetPlayer(source)
        if Player == nil then return end

        -- Check permission if restricted
        if SLCore.Commands.List[name].restricted then
            if Player.PlayerData.permission == permission then
                callback(source, args, rawCommand)
            else
                TriggerClientEvent('sl-core:client:notify', source, {
                    type = 'error',
                    message = 'No permission for this command',
                    duration = 5000
                })
            end
        else
            callback(source, args, rawCommand)
        end
    end, restricted)

    SLCore.Commands.List[name] = {
        name = name,
        permission = permission,
        help = help,
        arguments = arguments,
        argsrequired = argsrequired,
        restricted = restricted
    }
end

-- Register default commands
Citizen.CreateThread(function()
    -- Vehicle commands
    SLCore.Commands.Add("car", "Spawn a vehicle", {{name = "model", help = "Vehicle model name"}}, true, function(source, args)
        local Player = SLCore.Functions.GetPlayer(source)
        if not Player then return end
        
        if args[1] then
            SLCore.Functions.CreateVehicle(source, args[1])
        end
    end, "admin")

    SLCore.Commands.Add("dv", "Delete vehicle", {}, false, function(source)
        TriggerClientEvent('sl-core:client:deleteVehicle', source)
    end, "admin")

    -- Player commands
    SLCore.Commands.Add("id", "Check your id", {}, false, function(source)
        local Player = SLCore.Functions.GetPlayer(source)
        if not Player then return end
        
        TriggerClientEvent('sl-core:client:notify', source, {
            type = 'primary',
            message = 'ID: ' .. source,
            duration = 5000
        })
    end)

    -- Admin commands
    SLCore.Commands.Add("setjob", "Set a player's job", {
        {name = "id", help = "Player ID"},
        {name = "job", help = "Job name"},
        {name = "grade", help = "Job grade"}
    }, true, function(source, args)
        local Player = SLCore.Functions.GetPlayer(tonumber(args[1]))
        if not Player then return end

        Player.Functions.SetJob(args[2], tonumber(args[3]))
    end, "admin")

    SLCore.Commands.Add("setgang", "Set a player's gang", {
        {name = "id", help = "Player ID"},
        {name = "gang", help = "Gang name"},
        {name = "grade", help = "Gang grade"}
    }, true, function(source, args)
        local Player = SLCore.Functions.GetPlayer(tonumber(args[1]))
        if not Player then return end

        Player.Functions.SetGang(args[2], tonumber(args[3]))
    end, "admin")

    SLCore.Commands.Add("givemoney", "Give money to a player", {
        {name = "id", help = "Player ID"},
        {name = "type", help = "Type of money (cash, bank, crypto)"},
        {name = "amount", help = "Amount"}
    }, true, function(source, args)
        local Player = SLCore.Functions.GetPlayer(tonumber(args[1]))
        if not Player then return end

        Player.Functions.AddMoney(args[2], tonumber(args[3]), "Admin command")
    end, "admin")
end)
