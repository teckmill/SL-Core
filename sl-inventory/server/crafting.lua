local SLCore = exports['sl-core']:GetCoreObject()

-- Helper Functions
local function HasRequiredItems(source, recipe)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    for item, amount in pairs(recipe.items) do
        local playerItem = Player.Functions.GetItemByName(item)
        if not playerItem or playerItem.amount < amount then
            return false
        end
    end
    
    return true
end

local function RemoveRequiredItems(source, recipe)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    for item, amount in pairs(recipe.items) do
        Player.Functions.RemoveItem(item, amount)
    end
    
    return true
end

local function GetPlayerSkillLevel(source, skill)
    -- This function should be implemented based on your skill system
    -- For now, we'll return 0 to allow all crafting
    return 0
end

-- Event Handlers
RegisterNetEvent('sl-inventory:server:CraftItem', function(recipeName)
    local src = source
    local Player = SLCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local recipe = Config.Recipes[recipeName]
    if not recipe then
        TriggerClientEvent('sl-inventory:client:SendMessage', src, Lang:t('error.invalid_recipe'))
        return
    end
    
    -- Check skill requirement
    if recipe.skill and recipe.skillRequired then
        local playerSkill = GetPlayerSkillLevel(src, recipe.skill)
        if playerSkill < recipe.skillRequired then
            TriggerClientEvent('sl-inventory:client:SendMessage', src, Lang:t('error.skill_required'))
            return
        end
    end
    
    -- Check required items
    if not HasRequiredItems(src, recipe) then
        TriggerClientEvent('sl-inventory:client:SendMessage', src, Lang:t('error.missing_items'))
        return
    end
    
    -- Start crafting process
    TriggerClientEvent('sl-inventory:client:StartCrafting', src, recipe.time)
    
    -- Remove required items
    RemoveRequiredItems(src, recipe)
    
    -- Wait for crafting time
    Wait(recipe.time)
    
    -- Add crafted item
    local success = exports['sl-inventory']:AddItem(src, recipeName, 1)
    if success then
        -- Add crafting experience if skill system is implemented
        -- AddCraftingExperience(src, recipe.skill, recipe.experience)
        
        TriggerClientEvent('sl-inventory:client:SendMessage', src, Lang:t('success.item_crafted'))
    else
        -- Return items if crafting failed
        for item, amount in pairs(recipe.items) do
            exports['sl-inventory']:AddItem(src, item, amount)
        end
        TriggerClientEvent('sl-inventory:client:SendMessage', src, Lang:t('error.crafting_failed'))
    end
end)

-- Exports
exports('GetRecipes', function(source)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return {} end
    
    local recipes = {}
    for name, recipe in pairs(Config.Recipes) do
        if not recipe.skill or not recipe.skillRequired or GetPlayerSkillLevel(source, recipe.skill) >= recipe.skillRequired then
            recipes[name] = recipe
        end
    end
    
    return recipes
end)

exports('CanCraftRecipe', function(source, recipeName)
    local Player = SLCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local recipe = Config.Recipes[recipeName]
    if not recipe then return false end
    
    -- Check skill requirement
    if recipe.skill and recipe.skillRequired then
        local playerSkill = GetPlayerSkillLevel(source, recipe.skill)
        if playerSkill < recipe.skillRequired then
            return false
        end
    end
    
    -- Check required items
    return HasRequiredItems(source, recipe)
end)
