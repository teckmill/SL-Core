local SLCore = exports['sl-core']:GetCoreObject()

-- Menu Functions
function OpenCraftingMenu(station)
    local recipes = Config.Recipes[station]
    if not recipes then return end

    local menuItems = {}
    for item, recipe in pairs(recipes) do
        menuItems[#menuItems + 1] = {
            header = recipe.label,
            txt = GenerateRecipeDescription(recipe),
            icon = 'fas fa-hammer',
            params = {
                event = 'sl-crafting:client:showRecipeDetails',
                args = {
                    station = station,
                    item = item,
                    recipe = recipe
                }
            }
        }
    end

    exports['sl-menu']:openMenu(menuItems)
end

function GenerateRecipeDescription(recipe)
    local desc = Lang:t('info.required_ingredients') .. ':\\n'
    for item, amount in pairs(recipe.ingredients) do
        local itemLabel = SLCore.Shared.Items[item].label
        desc = desc .. '- ' .. itemLabel .. ' x' .. amount .. '\\n'
    end
    return desc
end

function ShowRecipeDetails(data)
    if not data.station or not data.item or not data.recipe then return end

    local menuItems = {
        {
            header = data.recipe.label,
            txt = GenerateRecipeDescription(data.recipe),
            icon = 'fas fa-info-circle',
            isMenuHeader = true
        },
        {
            header = Lang:t('menu.craft'),
            txt = Lang:t('info.crafting_progress'),
            icon = 'fas fa-hammer',
            params = {
                event = 'sl-crafting:client:craftItem',
                args = {
                    station = data.station,
                    item = data.item
                }
            }
        },
        {
            header = Lang:t('menu.back'),
            icon = 'fas fa-arrow-left',
            params = {
                event = 'sl-crafting:client:openCraftingMenu',
                args = data.station
            }
        }
    }

    exports['sl-menu']:openMenu(menuItems)
end

-- Events
RegisterNetEvent('sl-crafting:client:openCraftingMenu', function(station)
    OpenCraftingMenu(station)
end)

RegisterNetEvent('sl-crafting:client:showRecipeDetails', function(data)
    ShowRecipeDetails(data)
end)

RegisterNetEvent('sl-crafting:client:craftItem', function(data)
    if not data.station or not data.item then return end
    StartCrafting(data.station, data.item)
end)
