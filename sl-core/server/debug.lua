local function tPrint(tbl, indent)
    indent = indent or 0
    if type(tbl) == 'table' then
        for k, v in pairs(tbl) do
            local tblType = type(v)
            local formatting = ("%s ^3%s:^0"):format(string.rep("  ", indent), k)

            if tblType == "table" then
                print(formatting)
                tPrint(v, indent + 1)
            elseif tblType == 'boolean' then
                print(("%s ^1%s^0"):format(formatting, v))
            elseif tblType == "function" then
                print(("%s ^9%s^0"):format(formatting, v))
            elseif tblType == 'number' then
                print(("%s ^5%s^0"):format(formatting, v))
            elseif tblType == 'string' then
                print(("%s ^2'%s'^0"):format(formatting, v))
            else
                print(("%s ^2%s^0"):format(formatting, v))
            end
        end
    else
        print(("%s ^0%s^0"):format(string.rep("  ", indent), tbl))
    end
end

RegisterCommand('slprint', function(source, args)
    if source == 0 then
        if args[1] then
            local debugObject = args[1]
            if debugObject == 'players' then
                tPrint(SLCore.Players)
            elseif debugObject == 'jobs' then
                tPrint(SLCore.Shared.Jobs)
            elseif debugObject == 'gangs' then
                tPrint(SLCore.Shared.Gangs)
            elseif debugObject == 'items' then
                tPrint(SLCore.Shared.Items)
            elseif debugObject == 'vehicles' then
                tPrint(SLCore.Shared.Vehicles)
            elseif debugObject == 'commands' then
                tPrint(SLCore.Commands.List)
            elseif debugObject == 'all' then
                tPrint(SLCore)
            end
        end
    end
end, true)
