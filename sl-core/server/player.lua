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
                
                local Player = SLCore.Player.CreatePlayer(PlayerData, source)
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

function SLCore.Player.CreatePlayer(PlayerData, source)
    local self = {}
    self.Functions = {}
    self.PlayerData = PlayerData

    self.Functions.UpdatePlayerData = function()
        TriggerClientEvent('SLCore:Player:SetPlayerData', self.PlayerData.source, self.PlayerData)
        TriggerEvent('SLCore:Player:SetPlayerData', self.PlayerData.source, self.PlayerData)
    end

    self.Functions.SetJob = function(job, grade)
        local job = job:lower()
        local grade = tostring(grade) or '0'

        self.PlayerData.job.name = job
        self.PlayerData.job.grade = grade
        self.PlayerData.job.onduty = Config.Jobs[job].defaultDuty

        self.Functions.UpdatePlayerData()
        TriggerClientEvent('SLCore:Client:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
    end

    self.Functions.SetGang = function(gang, grade)
        local gang = gang:lower()
        local grade = tostring(grade) or '0'

        self.PlayerData.gang.name = gang
        self.PlayerData.gang.grade = grade

        self.Functions.UpdatePlayerData()
        TriggerClientEvent('SLCore:Client:OnGangUpdate', self.PlayerData.source, self.PlayerData.gang)
    end

    self.Functions.AddMoney = function(moneytype, amount, reason)
        reason = reason or 'unknown'
        local moneytype = moneytype:lower()
        local amount = tonumber(amount)

        if amount < 0 then return end

        self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] + amount

        self.Functions.UpdatePlayerData()
        TriggerEvent('SLCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, "add", reason)
        TriggerClientEvent('SLCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, "add", reason)

        return true
    end

    self.Functions.RemoveMoney = function(moneytype, amount, reason)
        reason = reason or 'unknown'
        local moneytype = moneytype:lower()
        local amount = tonumber(amount)

        if amount < 0 then return end

        if self.PlayerData.money[moneytype] - amount < 0 then
            return false
        end

        self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount

        self.Functions.UpdatePlayerData()
        TriggerEvent('SLCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, "remove", reason)
        TriggerClientEvent('SLCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, "remove", reason)

        return true
    end

    self.Functions.Save = function()
        MySQL.Async.execute('UPDATE players SET money = ?, job = ?, position = ?, metadata = ? WHERE citizenid = ?',
            {json.encode(self.PlayerData.money), json.encode(self.PlayerData.job), json.encode(self.PlayerData.position), json.encode(self.PlayerData.metadata), self.PlayerData.citizenid})
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
