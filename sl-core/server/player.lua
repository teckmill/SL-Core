SLCore.Player = {}
SLCore.Player.Login = function(source, citizenid, newData)
    if source and source ~= '' then
        if citizenid then
            -- Login with citizenid
        else
            -- Create new character
        end
        return true
    else
        return false
    end
end

SLCore.Player.Logout = function(source)
    TriggerClientEvent('SLCore:Client:OnPlayerUnload', source)
    SLCore.Players[source] = nil
end

SLCore.Player.CreateCitizenId = function()
    local UniqueFound = false
    local CitizenId = nil
    while not UniqueFound do
        CitizenId = tostring(SLCore.Shared.RandomStr(3) .. SLCore.Shared.RandomInt(5)):upper()
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE citizenid = ?', { CitizenId })
        if result == 0 then
            UniqueFound = true
        end
    end
    return CitizenId
end

SLCore.Player.Save = function(source)
    local PlayerData = SLCore.Players[source]
    if PlayerData then
        MySQL.update('UPDATE players SET money = ?, job = ?, position = ? WHERE citizenid = ?', {
            json.encode(PlayerData.money),
            json.encode(PlayerData.job),
            json.encode(PlayerData.position),
            PlayerData.citizenid
        })
    end
end
