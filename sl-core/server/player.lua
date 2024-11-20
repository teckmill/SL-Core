-- Player Class
SLCore.Player = {}
SLCore.Players = {}

-- Player Functions
function SLCore.Player.Login(source, citizenid, newData)
    if source and source ~= '' then
        if citizenid then
            local license = SLCore.Functions.GetIdentifier(source, 'license')
            local PlayerData = MySQL.prepare.await('SELECT * FROM players where citizenid = ?', { citizenid })
            if PlayerData then
                PlayerData.money = json.decode(PlayerData.money)
                PlayerData.job = json.decode(PlayerData.job)
                PlayerData.position = json.decode(PlayerData.position)
                PlayerData.metadata = json.decode(PlayerData.metadata)
                PlayerData.charinfo = json.decode(PlayerData.charinfo)
                
                local Player = SLCore.Player.CreatePlayer(PlayerData, license)
                SLCore.Players[source] = Player
                
                -- Set player routing bucket
                SetPlayerRoutingBucket(source, Player.PlayerData.id)
                
                -- Trigger login events
                TriggerClientEvent('sl-core:client:playerLoaded', source, Player.PlayerData)
                TriggerEvent('sl-core:server:playerLoaded', source, Player)
                
                return true
            end
        end
        return false
    end
end

function SLCore.Player.CreatePlayer(PlayerData, license)
    local self = {}
    self.Functions = {}
    self.PlayerData = PlayerData
    self.PlayerData.license = license
    
    function self.Functions.UpdatePlayerData()
        TriggerClientEvent('sl-core:client:playerDataUpdate', self.PlayerData.source, self.PlayerData)
    end
    
    function self.Functions.SetJob(job, grade)
        local oldJob = self.PlayerData.job
        job = job:lower()
        grade = tostring(grade) or '0'
        
        if SLShared.Jobs[job] then
            self.PlayerData.job = {
                name = job,
                label = SLShared.Jobs[job].label,
                payment = SLShared.Jobs[job].grades[grade].payment or 30,
                grade = {
                    name = SLShared.Jobs[job].grades[grade].name,
                    level = tonumber(grade)
                },
                onduty = SLShared.Jobs[job].defaultDuty
            }
            
            TriggerClientEvent('sl-core:client:jobUpdate', self.PlayerData.source, self.PlayerData.job)
            TriggerEvent('sl-core:server:jobUpdate', self.PlayerData.source, self.PlayerData.job, oldJob)
            return true
        end
        return false
    end
    
    function self.Functions.SetGang(gang, grade)
        local oldGang = self.PlayerData.gang
        gang = gang:lower()
        grade = tostring(grade) or '0'
        
        if SLShared.Gangs[gang] then
            self.PlayerData.gang = {
                name = gang,
                label = SLShared.Gangs[gang].label,
                grade = {
                    name = SLShared.Gangs[gang].grades[grade].name,
                    level = tonumber(grade)
                }
            }
            
            TriggerClientEvent('sl-core:client:gangUpdate', self.PlayerData.source, self.PlayerData.gang)
            TriggerEvent('sl-core:server:gangUpdate', self.PlayerData.source, self.PlayerData.gang, oldGang)
            return true
        end
        return false
    end
    
    function self.Functions.SetPlayerData(key, val)
        if key and val then
            self.PlayerData[key] = val
            self.Functions.UpdatePlayerData()
        end
    end
    
    function self.Functions.AddMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        local moneytype = moneytype:lower()
        local amount = tonumber(amount)
        if amount < 0 then return end
        
        if self.PlayerData.money[moneytype] then
            self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] + amount
            self.Functions.UpdatePlayerData()
            TriggerClientEvent('sl-core:client:moneyChange', self.PlayerData.source, moneytype, amount, "add", reason)
            return true
        end
        return false
    end
    
    function self.Functions.RemoveMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        local moneytype = moneytype:lower()
        local amount = tonumber(amount)
        if amount < 0 then return end
        
        if self.PlayerData.money[moneytype] then
            for _, mtype in pairs(moneytype) do
                if self.PlayerData.money[mtype] >= amount then
                    self.PlayerData.money[mtype] = self.PlayerData.money[mtype] - amount
                    self.Functions.UpdatePlayerData()
                    TriggerClientEvent('sl-core:client:moneyChange', self.PlayerData.source, mtype, amount, "remove", reason)
                    return true
                end
            end
        end
        return false
    end
    
    function self.Functions.SetMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        local moneytype = moneytype:lower()
        local amount = tonumber(amount)
        if amount < 0 then return end
        
        if self.PlayerData.money[moneytype] then
            self.PlayerData.money[moneytype] = amount
            self.Functions.UpdatePlayerData()
            TriggerClientEvent('sl-core:client:moneyChange', self.PlayerData.source, moneytype, amount, "set", reason)
            return true
        end
        return false
    end
    
    function self.Functions.GetMoney(moneytype)
        if moneytype then
            moneytype = moneytype:lower()
            return self.PlayerData.money[moneytype]
        end
        return false
    end
    
    function self.Functions.SetMetaData(meta, val)
        if meta and val then
            self.PlayerData.metadata[meta] = val
            self.Functions.UpdatePlayerData()
        end
    end
    
    function self.Functions.GetMetaData(meta)
        if meta then
            return self.PlayerData.metadata[meta]
        end
        return self.PlayerData.metadata
    end
    
    function self.Functions.Save()
        MySQL.update('UPDATE players SET money = ?, job = ?, position = ?, metadata = ?, charinfo = ?, gang = ? WHERE citizenid = ?', {
            json.encode(self.PlayerData.money),
            json.encode(self.PlayerData.job),
            json.encode(self.PlayerData.position),
            json.encode(self.PlayerData.metadata),
            json.encode(self.PlayerData.charinfo),
            json.encode(self.PlayerData.gang),
            self.PlayerData.citizenid
        })
    end
    
    return self
end

-- Get Player
function SLCore.Functions.GetPlayer(source)
    if type(source) == 'number' then
        return SLCore.Players[source]
    end
    return nil
end

-- Get Players
function SLCore.Functions.GetPlayers()
    local sources = {}
    for k, v in pairs(SLCore.Players) do
        sources[#sources+1] = k
    end
    return sources
end

-- Get Player By Citizen ID
function SLCore.Functions.GetPlayerByCitizenId(citizenid)
    for src, player in pairs(SLCore.Players) do
        if player.PlayerData.citizenid == citizenid then
            return player
        end
    end
    return nil
end

-- Get Player By Phone Number
function SLCore.Functions.GetPlayerByPhone(number)
    for src, player in pairs(SLCore.Players) do
        if player.PlayerData.charinfo.phone == number then
            return player
        end
    end
    return nil
end

-- Save All Players
function SLCore.Player.SavePlayers()
    for _, player in pairs(SLCore.Players) do
        player.Functions.Save()
    end
end
