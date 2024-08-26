-- RegisterNUICallback for retrieving societies
-- @param data: The data received from the NUI callback
-- @param cb: The callback function to send the response
    RegisterNUICallback('getSocietys', function(data, cb)
        local societies = society_management_callback_getSocietys()
        cb({societies})
    end)
    
    -- RegisterNUICallback for adding a society
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('addSociety', function(data, cb)
        local success = society_management_callback_addSociety(data.society)
        if success then
            local updatedSocieties = society_management_callback_getSocietys()
            cb({ success = true, societies = updatedSocieties })
        else
            cb({ success = false, error = "Failed to add society" })
        end
    end)
    
    -- RegisterNUICallback for deleting a society
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('deleteSociety', function(data, cb)
        local success = society_management_callback_deleteSociety(data.society)
        if success then
            local updatedSocieties = society_management_callback_getSocietys()
            cb({ success = true, societies = updatedSocieties })
        else
            cb({ success = false, error = "Failed to delete society" })
        end
    end)
    
    -- RegisterNUICallback for editing a society
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('editSociety', function(data, cb)
        local success = society_management_callback_editSociety(data.society)
        if success then
            local updatedSocieties = society_management_callback_getSocietys()
            cb({ success = true, societies = updatedSocieties })
        else
            cb({ success = false, error = "Failed to edit society" })
        end
    end)
    
    -- RegisterNUICallback for withdrawing money from a society
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('withdrawSocietyMoney', function(data, cb)
        local success = society_management_callback_withdrawSocietyMoney(data.society, data.amount)
     
        if success then
            cb({ success = true})
        else
            cb({ success = false, error = "Failed to withdraw money" })
        end
    end)
    
    -- RegisterNUICallback for depositing money into a society
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('depositSocietyMoney', function(data, cb)
        local success = society_management_callback_depositSocietyMoney(data.society, data.amount)
        if success then
            cb({ success = true})
        else
            cb({ success = false, error = "Failed to deposit money" })
        end
    end)
    
    -- RegisterNUICallback for setting the amount of money in a society
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('setSocietyMoney', function(data, cb)
        local success = society_management_callback_setSocietyMoney(data.society, data.amount)
        if success then
            cb({ success = true, newAmount = data.amount })
        else
            cb({ success = false, error = "Failed to set society money" })
        end
    end)
    