-- Stolen from https://gist.github.com/FrazzIe/756b644f3d7ab5bf3f8c917793f8ac71
-- Credit to FrazzIe for the original script. He's awesome!

local tabletActive = false
local tabletDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local tabletAnim = "base"
local tabletProp = "prop_cs_tablet"
local tabletBone = 60309
local tabletOffset = vector3(0.03, 0.002, -0.0)
local tabletRot = vector3(10.0, 160.0, 0.0)

local tabletObj = nil -- Store the tablet object

--[[
    ToggleTablet
    Toggles the visibility of the tablet. If enabled, the player will hold a tablet and play an animation.
    If disabled, the tablet is removed.

    @param toggle (boolean): Whether to enable or disable the tablet.
]]
function ToggleTablet(toggle)
    if toggle and not tabletActive then
        tabletActive = true

        Citizen.CreateThread(function()
            -- Request the animation dictionary and tablet model
            RequestAnimDict(tabletDict)
            while not HasAnimDictLoaded(tabletDict) do
                Citizen.Wait(150)
            end

            RequestModel(tabletProp)
            while not HasModelLoaded(tabletProp) do
                Citizen.Wait(150)
            end

            local playerPed = PlayerPedId()
            tabletObj = CreateObject(tabletProp, 0.0, 0.0, 0.0, true, true, false)
            local tabletBoneIndex = GetPedBoneIndex(playerPed, tabletBone)

            SetCurrentPedWeapon(playerPed, `weapon_unarmed`, true)
            AttachEntityToEntity(tabletObj, playerPed, tabletBoneIndex, tabletOffset.x, tabletOffset.y, tabletOffset.z, tabletRot.x, tabletRot.y, tabletRot.z, true, false, false, false, 2, true)
            SetModelAsNoLongerNeeded(tabletProp)

            while tabletActive do
                Citizen.Wait(100)
                playerPed = PlayerPedId()

                if not IsEntityPlayingAnim(playerPed, tabletDict, tabletAnim, 3) then
                    TaskPlayAnim(playerPed, tabletDict, tabletAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                end

                -- Check if the player dies
                if IsPedDeadOrDying(playerPed, true) then
                    ToggleTablet(false)
                end
            end

            -- Cleanup after toggling off
            ClearPedSecondaryTask(playerPed)
            DetachEntity(tabletObj, true, false)
            DeleteEntity(tabletObj)
            tabletObj = nil
        end)
    elseif not toggle and tabletActive then
        tabletActive = false
        if tabletObj then
            DetachEntity(tabletObj, true, false)
            DeleteEntity(tabletObj)
            tabletObj = nil
            Wait(1500)
            ClearPedTasksImmediately(PlayerPedId())
        end
    end
end

--[[
    Event handler for resource stop
    Ensures that the tablet is removed when the resource is stopped.
]]
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then 
        if tabletActive then
            ClearPedTasksImmediately(PlayerPedId())
            ToggleTablet(false)
        end
    end
end)


--[[
    Event handler for when the player dies
    Automatically removes the tablet if the player dies.
]]
AddEventHandler('baseevents:onPlayerDied', function()
    if tabletActive then
        ToggleTablet(false)
    end
end)

AddEventHandler('baseevents:onPlayerKilled', function()
    if tabletActive then
        ToggleTablet(false)
    end
end)
