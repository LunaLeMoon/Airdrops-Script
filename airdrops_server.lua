local allowedRoles = {
    'admin',
    'moderator'
}

local propModel = "hei_prop_carrier_cargo_04a" -- you can change the prop that spawns here. 
local props = {}

RegisterCommand("airdrops", function(source, args)
    local player = source
    local playerRole = "default"

    for _, role in ipairs(allowedRoles) do
        if playerRole == role then
            SpawnAirdropProps(player)
            return
        end
    end

    TriggerClientEvent("chat:addMessage", player, {
        color = {255, 0, 0},
        multiline = true,
        args = {"System", "You do not have permission to use this command."}
    })
end)

function SpawnAirdropProps(player)
    for i, location in ipairs(Config.SpawnLocations) do
        local prop = CreateObject(GetHashKey(propModel), location.x, location.y, location.z, true, true, true)
        SetEntityAsMissionEntity(prop, true, true)
        SetEntityDynamic(prop, true)

        table.insert(props, {
            prop = prop,
            despawnTime = GetGameTimer() + 30 * 60 * 1000
        })
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for i = #props, 1, -1 do
            local propData = props[i]
            if propData then
                if GetGameTimer() >= propData.despawnTime then
                    DespawnProp(propData)
                end
            end
        end
    end
end)

function DespawnProp(propData)
    if DoesEntityExist(propData.prop) then
        DeleteEntity(propData.prop)
    end
    table.remove(props, propData)
end