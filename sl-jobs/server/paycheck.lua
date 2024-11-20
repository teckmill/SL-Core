local SLCore = exports['sl-core']:GetCoreObject()
local PaycheckLoop = nil

-- Initialize Paychecks
CreateThread(function()
    StartPaycheckLoop()
end)

function StartPaycheckLoop()
    if PaycheckLoop then return end
    
    local function PaycheckTick()
        local Players = SLCore.Functions.GetPlayers()
        
        for _, player in ipairs(Players) do
            local Player = SLCore.Functions.GetPlayer(player)
            if Player then
                ProcessPaycheck(Player)
            end
        end
        
        -- Set the next timeout
        PaycheckLoop = SetTimeout(Config.PaycheckInterval * 60000, PaycheckTick)
    end
    
    -- Start the first tick
    PaycheckTick()
end

function ProcessPaycheck(Player)
    local job = Player.PlayerData.job
    local jobConfig = Config.Jobs[job.name]
    if not jobConfig then return end
    
    -- Check if player should receive paycheck
    if not jobConfig.offDutyPay and not Player.PlayerData.job.onduty then
        return
    end
    
    -- Calculate base payment
    local payment = jobConfig.grades[tostring(job.grade)].payment
    
    -- Calculate bonuses
    local bonus = CalculateBonus(Player)
    local total = payment + bonus
    
    -- Process deductions
    local deductions = ProcessDeductions(Player, total)
    total = total - deductions
    
    -- Add payment
    Player.Functions.AddMoney('bank', total, 'paycheck')
    
    -- Send notification
    TriggerClientEvent('SLCore:Notify', Player.PlayerData.source, 'Paycheck received: $' .. total, 'success')
    
    -- Log payment
    LogPaycheck(Player.PlayerData.citizenid, total, payment, bonus, deductions)
end

function CalculateBonus(Player)
    local bonus = 0
    local citizenid = Player.PlayerData.citizenid
    
    -- Skill bonuses
    if Config.UseSkillSystem then
        local skills = JobData[citizenid].skills
        for skill, data in pairs(skills) do
            if Config.Skills[skill] then
                bonus = bonus + (data.level * Config.Skills[skill].bonusPerLevel)
            end
        end
    end
    
    -- Performance bonuses
    -- Add your performance bonus calculations here
    
    return bonus
end

function ProcessDeductions(Player, amount)
    local deductions = 0
    
    -- Process insurance
    if Config.Benefits.insurance.enabled then
        deductions = deductions + (amount * Config.Benefits.insurance.cost)
    end
    
    -- Process retirement
    if Config.Benefits.retirement.enabled then
        local retirement = amount * Config.Benefits.retirement.matchRate
        deductions = deductions + retirement
        -- Add to retirement account
        -- Add your retirement system logic here
    end
    
    -- Tax deductions
    -- Add your tax system logic here
    
    return deductions
end

function LogPaycheck(citizenid, total, base, bonus, deductions)
    MySQL.Async.execute([[
        INSERT INTO job_logs (citizenid, job, action, details)
        VALUES (?, ?, 'paycheck', ?)
    ]], {
        citizenid,
        JobData[citizenid].job,
        json.encode({
            total = total,
            base = base,
            bonus = bonus,
            deductions = deductions,
            timestamp = os.time()
        })
    })
end

-- Exports
exports('ProcessPaycheck', ProcessPaycheck)
exports('CalculateBonus', CalculateBonus) 