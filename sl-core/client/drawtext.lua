local function Draw3DText(x, y, z, text)
    -- Get screen coords from world coords
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        -- Calculate text scale to use
        local dist = #(GetGameplayCamCoords() - vector3(x, y, z))
        local scale = 1.8 * (1 / dist) * (1 / GetGameplayCamFov()) * 100

        -- Draw text on screen
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

local function DrawText(text, position)
    if not position then position = "left" end
    
    SendNUIMessage({
        action = 'DRAW_TEXT',
        data = {
            text = text,
            position = position
        }
    })
end

local function HideText()
    SendNUIMessage({
        action = 'HIDE_TEXT'
    })
end

local function ChangeText(text, position)
    SendNUIMessage({
        action = 'CHANGE_TEXT',
        data = {
            text = text,
            position = position
        }
    })
end

exports('Draw3DText', Draw3DText)
exports('DrawText', DrawText)
exports('HideText', HideText)
exports('ChangeText', ChangeText)
