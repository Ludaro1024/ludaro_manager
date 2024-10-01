-- Callback to get all vehicles
RegisterNUICallback("getVehicles", function(data, cb)
    local vehicles = vehicle_management_getVehicles()  -- Replace with your function to fetch vehicles from the database
    local result = {}
    
    for _, vehicle in pairs(vehicles) do
        
        modelhash = json.decode(vehicle.vehicle)?.model
        vehicleModelName = GetDisplayNameFromVehicleModel(modelhash)
        table.insert(result, {
            owner = vehicle.owner,  -- Identifier
            name = vehicle.name,
            plate = vehicle.plate,
            vehicle = vehicle.vehicle,
            model = vehicleModelName,
            job = vehicle.job,
            stored = vehicle.stored
        })
    end

    cb({ success = true, vehicles = result })
end)

RegisterNUICallback("editVehicle", function(data, cb)

    local oldPlate = data.oldPlate  -- Original plate
    local newPlate = data.newPlate  -- Modified plate
    local newModel = data.newModel  -- Modified model
    local newOwner = data.newOwner  -- Modified owner identifier
    local stored = data.stored

    -- Fetch the original vehicle row from the database using the old plate
    local vehicle = vehicle_management_getVehiclebyPlate(oldPlate)

    if vehicle then
        -- Update the vehicle data with the new information
        if newModel then
            vehicle.vehicle = json.encode({ model = newModel })
        end

        vehicle.plate = newPlate
        vehicle.owner = newOwner
        vehicle.stored = stored

        -- Update in the database using the old plate to identify the vehicle
        local success = vehicle_management_editVehicleInDatabase(vehicle, oldPlate)

        if success then
            cb({ success = true, vehicle = vehicle })
        else
            cb({ success = false, error = "Failed to update vehicle information." })
        end
    else
        cb({ success = false, error = "Vehicle not found." })
    end
end)


-- Callback to add a new vehicle
RegisterNUICallback("addVehicle", function(data, cb)
    local newVehicle = {
        plate = data.newPlate,
        model = data.newModel,
        owner = data.newOwner,
        job = data.newJob,
        stored = data.stored
    }

    ismodelvalid = IsModelInCdimage(newVehicle.model)
    if not ismodelvalid then
        cb({ success = false, error = "Model is not valid." })
        return
    end

    local success, vehicle = vehicle_management_addVehicleToDatabase(newVehicle)

    if success then
        cb({ success = true, vehicle = vehicle })
    else
        cb({ success = false, error = "Failed to add vehicle." })
    end
end)



RegisterNuiCallback("deleteVehicle", function(data, cb)
    local plate = data.vehicle.plate  -- Plate of the vehicle to delete

    local success = vehicle_management_deleteVehicle(plate)

    if success then
        cb({ success = true })
    else
        cb({ success = false, error = "Failed to delete vehicle." })
    end
end)