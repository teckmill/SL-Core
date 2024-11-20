local SLCore = exports['sl-core']:GetCoreObject()

-- Society Configuration
local Societies = {}
local DefaultGrade = {
    name = 'No Grade',
    payment = 0,
    isboss = false
}

-- Society Functions
function CreateSociety(name, label, account)
    if Societies[name] then return false end
    
    Societies[name] = {
        label = label,
        account = account,
        grades = {},
        members = {}
    }
    
    MySQL.insert('INSERT INTO job_societies (name, label, account) VALUES (?, ?, ?)',
        {name, label, account})
    
    return true
end

function GetSociety(name)
    return Societies[name]
end

function GetSocietyAccount(name)
    local society = Societies[name]
    if not society then return nil end
    return society.account
end

function AddSocietyMoney(name, amount)
    local society = Societies[name]
    if not society then return false end
    
    local result = MySQL.update.await('UPDATE job_societies SET money = money + ? WHERE name = ?',
        {amount, name})
    
    return result > 0
end

function RemoveSocietyMoney(name, amount)
    local society = Societies[name]
    if not society then return false end
    
    local result = MySQL.update.await('UPDATE job_societies SET money = money - ? WHERE name = ?',
        {amount, name})
    
    return result > 0
end

function GetSocietyMoney(name)
    local result = MySQL.single.await('SELECT money FROM job_societies WHERE name = ?', {name})
    return result and result.money or 0
end

-- Grade Management
function AddGrade(society, grade, data)
    if not Societies[society] then return false end
    
    Societies[society].grades[grade] = {
        name = data.name or DefaultGrade.name,
        payment = data.payment or DefaultGrade.payment,
        isboss = data.isboss or DefaultGrade.isboss
    }
    
    MySQL.insert('INSERT INTO job_grades (job_name, grade, name, payment, isboss) VALUES (?, ?, ?, ?, ?)',
        {society, grade, data.name, data.payment, data.isboss})
    
    return true
end

function RemoveGrade(society, grade)
    if not Societies[society] or not Societies[society].grades[grade] then return false end
    
    Societies[society].grades[grade] = nil
    MySQL.query('DELETE FROM job_grades WHERE job_name = ? AND grade = ?', {society, grade})
    
    return true
end

-- Member Management
function AddMember(society, identifier, grade)
    if not Societies[society] then return false end
    
    Societies[society].members[identifier] = grade
    MySQL.insert('INSERT INTO society_members (society, identifier, grade) VALUES (?, ?, ?)',
        {society, identifier, grade})
    
    return true
end

function RemoveMember(society, identifier)
    if not Societies[society] or not Societies[society].members[identifier] then return false end
    
    Societies[society].members[identifier] = nil
    MySQL.query('DELETE FROM society_members WHERE society = ? AND identifier = ?',
        {society, identifier})
    
    return true
end

-- Events
RegisterNetEvent('sl-jobs:server:CreateSociety')
AddEventHandler('sl-jobs:server:CreateSociety', function(name, label, account)
    local src = source
    if not SLCore.Functions.HasPermission(src, 'admin') then return end
    
    local success = CreateSociety(name, label, account)
    if success then
        TriggerClientEvent('SLCore:Notify', src, 'Society created successfully', 'success')
    else
        TriggerClientEvent('SLCore:Notify', src, 'Failed to create society', 'error')
    end
end)

RegisterNetEvent('sl-jobs:server:AddSocietyMoney')
AddEventHandler('sl-jobs:server:AddSocietyMoney', function(society, amount)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Check if player has permission
    if not Player.PlayerData.job.isboss then return end
    
    local success = AddSocietyMoney(society, amount)
    if success then
        TriggerClientEvent('SLCore:Notify', src, 'Added $' .. amount .. ' to society account', 'success')
    else
        TriggerClientEvent('SLCore:Notify', src, 'Failed to add money to society', 'error')
    end
end)

-- Callbacks
SLCore.Functions.CreateCallback('sl-jobs:server:GetSocietyMoney', function(source, cb, society)
    local money = GetSocietyMoney(society)
    cb(money)
end)

SLCore.Functions.CreateCallback('sl-jobs:server:GetSocietyGrades', function(source, cb, society)
    if not Societies[society] then return cb({}) end
    cb(Societies[society].grades)
end)

-- Initialize
CreateThread(function()
    -- Load societies from database
    local results = MySQL.query.await('SELECT * FROM job_societies')
    for _, society in ipairs(results) do
        Societies[society.name] = {
            label = society.label,
            account = society.account,
            grades = {},
            members = {}
        }
    end
    
    -- Load grades
    local grades = MySQL.query.await('SELECT * FROM job_grades')
    for _, grade in ipairs(grades) do
        if Societies[grade.job_name] then
            Societies[grade.job_name].grades[grade.grade] = {
                name = grade.name,
                payment = grade.payment,
                isboss = grade.isboss
            }
        end
    end
    
    -- Load members
    local members = MySQL.query.await('SELECT * FROM society_members')
    for _, member in ipairs(members) do
        if Societies[member.society] then
            Societies[member.society].members[member.identifier] = member.grade
        end
    end
end)
