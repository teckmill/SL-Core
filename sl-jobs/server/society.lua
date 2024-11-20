local SLCore = exports['sl-core']:GetCoreObject()

-- Society Configuration
local Societies = {}
local DefaultGrade = {
    name = 'Employee',
    payment = 0,
    isboss = false
}

-- Initialize Database Tables
local function InitializeDatabase()
    MySQL.ready(function()
        MySQL.Sync.execute([[
            CREATE TABLE IF NOT EXISTS `job_societies` (
                `name` varchar(50) NOT NULL,
                `label` varchar(50) NOT NULL,
                `money` int(11) NOT NULL DEFAULT 0,
                `owner` varchar(60) DEFAULT NULL,
                PRIMARY KEY (`name`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])

        MySQL.Sync.execute([[
            CREATE TABLE IF NOT EXISTS `job_grades` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `job_name` varchar(50) NOT NULL,
                `grade` int(11) NOT NULL,
                `name` varchar(50) NOT NULL,
                `payment` int(11) NOT NULL DEFAULT 0,
                `isboss` tinyint(1) NOT NULL DEFAULT 0,
                PRIMARY KEY (`id`),
                UNIQUE KEY `job_grade` (`job_name`, `grade`),
                CONSTRAINT `fk_job_grades_societies` 
                FOREIGN KEY (`job_name`) 
                REFERENCES `job_societies` (`name`) 
                ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])

        MySQL.Sync.execute([[
            CREATE TABLE IF NOT EXISTS `society_members` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `society` varchar(50) NOT NULL,
                `identifier` varchar(60) NOT NULL,
                `grade` int(11) NOT NULL DEFAULT 0,
                `name` varchar(255) DEFAULT NULL,
                `joined_at` timestamp NOT NULL DEFAULT current_timestamp(),
                PRIMARY KEY (`id`),
                UNIQUE KEY `society_member` (`society`, `identifier`),
                CONSTRAINT `fk_society_members_societies` 
                FOREIGN KEY (`society`) 
                REFERENCES `job_societies` (`name`) 
                ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])

        print('^2[SL-Jobs] ^7Database tables initialized successfully')
    end)
end

-- Initialize on resource start
CreateThread(function()
    InitializeDatabase()
    Wait(1000) -- Wait for database tables to be created

    -- Load societies from database
    local results = MySQL.query.await('SELECT * FROM job_societies')
    if results then
        for _, society in ipairs(results) do
            Societies[society.name] = {
                label = society.label,
                money = society.money,
                owner = society.owner,
                grades = {},
                members = {}
            }
        end
    end
    
    -- Load grades
    local grades = MySQL.query.await('SELECT * FROM job_grades')
    if grades then
        for _, grade in ipairs(grades) do
            if Societies[grade.job_name] then
                Societies[grade.job_name].grades[grade.grade] = {
                    name = grade.name,
                    payment = grade.payment,
                    isboss = grade.isboss == 1
                }
            end
        end
    end

    -- Load members
    local members = MySQL.query.await('SELECT * FROM society_members')
    if members then
        for _, member in ipairs(members) do
            if Societies[member.society] then
                Societies[member.society].members[member.identifier] = {
                    grade = member.grade,
                    name = member.name,
                    joined_at = member.joined_at
                }
            end
        end
    end
end)

-- Society Functions
function CreateSociety(name, label, account)
    if Societies[name] then return false end
    
    Societies[name] = {
        label = label,
        money = 0,
        owner = account,
        grades = {},
        members = {}
    }
    
    MySQL.insert('INSERT INTO job_societies (name, label, money, owner) VALUES (?, ?, ?, ?)',
        {name, label, 0, account})
    
    return true
end

function GetSociety(name)
    return Societies[name]
end

function GetSocietyAccount(name)
    local society = Societies[name]
    if not society then return nil end
    return society.owner
end

function AddSocietyMoney(name, amount)
    local society = Societies[name]
    if not society then return false end
    
    society.money = society.money + amount
    MySQL.update('UPDATE job_societies SET money = money + ? WHERE name = ?', {amount, name})
    
    return true
end

function RemoveSocietyMoney(name, amount)
    local society = Societies[name]
    if not society or society.money < amount then return false end
    
    society.money = society.money - amount
    MySQL.update('UPDATE job_societies SET money = money - ? WHERE name = ?', {amount, name})
    
    return true
end

function AddGrade(society, grade, data)
    if not Societies[society] then return false end
    if Societies[society].grades[grade] then return false end
    
    Societies[society].grades[grade] = {
        name = data.name or DefaultGrade.name,
        payment = data.payment or DefaultGrade.payment,
        isboss = data.isboss or DefaultGrade.isboss
    }
    
    MySQL.insert('INSERT INTO job_grades (job_name, grade, name, payment, isboss) VALUES (?, ?, ?, ?, ?)',
        {society, grade, data.name, data.payment, data.isboss and 1 or 0})
    
    return true
end

function RemoveGrade(society, grade)
    if not Societies[society] or not Societies[society].grades[grade] then return false end
    
    Societies[society].grades[grade] = nil
    MySQL.execute('DELETE FROM job_grades WHERE job_name = ? AND grade = ?', {society, grade})
    
    return true
end

-- Callbacks
SLCore.Functions.CreateCallback('sl-jobs:server:GetSocieties', function(source, cb)
    local societies = {}
    for name, data in pairs(Societies) do
        societies[name] = {
            label = data.label,
            grades = data.grades
        }
    end
    cb(societies)
end)

SLCore.Functions.CreateCallback('sl-jobs:server:GetSociety', function(source, cb, society)
    if not Societies[society] then return cb(nil) end
    cb(Societies[society])
end)

SLCore.Functions.CreateCallback('sl-jobs:server:GetSocietyGrades', function(source, cb, society)
    if not Societies[society] then return cb({}) end
    cb(Societies[society].grades)
end)

-- Events
RegisterNetEvent('sl-jobs:server:AddSocietyMoney', function(society, amount)
    local source = source
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end
    
    -- Check if player has permission
    local member = Societies[society] and Societies[society].members[Player.PlayerData.citizenid]
    if not member or not Societies[society].grades[member.grade].isboss then return end
    
    AddSocietyMoney(society, amount)
end)

RegisterNetEvent('sl-jobs:server:RemoveSocietyMoney', function(society, amount)
    local source = source
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return end
    
    -- Check if player has permission
    local member = Societies[society] and Societies[society].members[Player.PlayerData.citizenid]
    if not member or not Societies[society].grades[member.grade].isboss then return end
    
    RemoveSocietyMoney(society, amount)
end)
