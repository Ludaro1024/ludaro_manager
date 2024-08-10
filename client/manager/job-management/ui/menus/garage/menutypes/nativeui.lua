if Config.Menu == "NativeUI" then
    function openGarageMenu(data) 
    --     local menu = NativeUI.CreateMenu(Locale("garage"), "")
    --     _menuPool:Add(menu)
        
    --     sharedvehicles, personalvehicles = garage_getGarageData()
    --     if sharedvehicles == nil or personalvehicles == nil or #personalvehicles == 0 or #sharedvehicles == 0 then
    --         EditableFunctions.Notify(Locale("no_vehicles"))
    --         return
    --     end

    --     local sharedjobvehicles = _menuPool:AddSubMenu(menu, Locale("shared_vehicles"), "")
    --     local personaljobvehicles = _menuPool:AddSubMenu(menu, Locale("personal_vehicles"), "")
       
    --     if #sharedvehicles > 0 then
    --     for k, v in pairs(sharedvehicles) do
    --         local vehicle = NativeUI.CreateItem(v.vehicle, "")
    --         sharedjobvehicles.SubMenu:AddItem(vehicle)
    --         vehicle.Activated = function(sender, item)
    --             if item == vehicle then
    --                 ESX.Game.SpawnVehicle(v.model, {x = v.garageCoords.x, y = v.garageCoords.y, z = v.garageCoords.z}, v.heading, function(spawnedVehicle)
    --                     ESX.Game.SetVehicleProperties(spawnedVehicle, v)
    --                 end)
    --             else
    --                 EditableFunctions.Notify(Locale("error"))
    --             end
    --         end
    --     end
    -- end 

    -- if #personalvehicles > 0 then
    --     for k, v in pairs(personalvehicles) do
    --         local vehicle = NativeUI.CreateItem(v.vehicle, "")
    --         personaljobvehicles.SubMenu:AddItem(vehicle)
    --         vehicle.Activated = function(sender, item)
    --             if item == vehicle then
    --                 local cb = garage_parkout(v)
    --                 if cb then
    --                     ESX.Game.SpawnVehicle(v.model, {x = v.garageCoords.x, y = v.garageCoords.y, z = v.garageCoords.z}, v.heading, function(spawnedVehicle)
    --                         ESX.Game.SetVehicleProperties(spawnedVehicle, v)
    --                     end)
    --                 else
    --                     EditableFunctions.Notify(Locale("error"))
    --                 end
    --             end
    --         end
    --     end
    -- end

    --     local parkin = _menuPool:AddSubMenu(menu, Locale("park_in"), "")

    --     local vehiclesnearby = garage_framework_getVehiclesNearby()

    --     for k, v in pairs(vehiclesnearby) do
    --         local plate = GetVehicleNumberPlateText(v.vehicle)
    --         local vehicle = NativeUI.CreateItem(plate, "")
    --         parkin.SubMenu:AddItem(vehicle)
    --         vehicle.Activated = function(sender, item)
    --             if item == vehicle then
    --                 local cb = garage_parkin(v)
    --                 if cb then
    --                     ESX.Game.DeleteVehicle(v.vehicle)
    --                 else
    --                     EditableFunctions.Notify(Locale("error"))
    --                 end
    --             end
    --         end
    --     end

    --     _menuPool:RefreshIndex()
    --     _menuPool:MouseControlsEnabled(false)
    --     _menuPool:ControlDisablingEnabled(false)
    --     menu:Visible(true)
    --     print("what")
    end
end


