local SLCore = exports['sl-core']:GetCoreObject()
local PlayerData = {}
local CurrentBusiness = nil

-- Initialize
RegisterNetEvent('SLCore:Client:OnPlayerLoaded', function()
    PlayerData = SLCore.Functions.GetPlayerData()
    LoadPlayerBusinesses()
end)

RegisterNetEvent('SLCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

-- Core Functions
function LoadPlayerBusinesses()
    SLCore.Functions.TriggerCallback('sl-business:server:getBusinesses', function(businesses)
        for _, business in pairs(businesses) do
            -- Initialize business blips and zones
            CreateBusinessBlip(business)
            CreateBusinessZone(business)
        end
    end)
end

function CreateBusinessBlip(business)
    local businessType = Config.BusinessTypes[business.type]
    if not businessType or not businessType.blip then return end

    local blip = AddBlipForCoord(business.coords.x, business.coords.y, business.coords.z)
    SetBlipSprite(blip, businessType.blip.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, businessType.blip.scale or 0.7)
    SetBlipColour(blip, businessType.blip.color or 0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(business.name)
    EndTextCommandSetBlipName(blip)
end

function CreateBusinessZone(business)
    exports['sl-target']:AddBoxZone(
        "business_" .. business.id,
        vector3(business.coords.x, business.coords.y, business.coords.z),
        2.0, 2.0,
        {
            name = "business_" .. business.id,
            heading = business.coords.w,
            debugPoly = false,
            minZ = business.coords.z - 1,
            maxZ = business.coords.z + 2,
        },
        {
            options = {
                {
                    type = "client",
                    event = "sl-business:client:openMenu",
                    icon = "fas fa-building",
                    label = Lang:t('info.business_menu'),
                    businessId = business.id,
                    canInteract = function()
                        return business.owner == PlayerData.citizenid
                    end,
                }
            },
            distance = 2.5
        }
    )
end

-- Events
RegisterNetEvent('sl-business:client:openMenu', function(data)
    if not data.businessId then return end
    
    SLCore.Functions.TriggerCallback('sl-business:server:getBusiness', function(business)
        if not business then return end
        CurrentBusiness = business
        OpenBusinessMenu()
    end, data.businessId)
end)

RegisterNetEvent('sl-business:client:businessCreated', function(businessId)
    SLCore.Functions.TriggerCallback('sl-business:server:getBusiness', function(business)
        if business then
            CreateBusinessBlip(business)
            CreateBusinessZone(business)
        end
    end, businessId)
end)

RegisterNetEvent('sl-business:client:businessUpdated', function(businessId, data)
    if CurrentBusiness and CurrentBusiness.id == businessId then
        for k, v in pairs(data) do
            CurrentBusiness[k] = v
        end
    end
end)

RegisterNetEvent('sl-business:client:transactionProcessed', function(businessId, data)
    if CurrentBusiness and CurrentBusiness.id == businessId then
        if data.type == 'deposit' then
            CurrentBusiness.funds = CurrentBusiness.funds + data.amount
        else
            CurrentBusiness.funds = CurrentBusiness.funds - data.amount
        end
    end
end)

-- Export
exports('GetCurrentBusiness', function()
    return CurrentBusiness
end)
