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
        society_management_callback_addSociety(data.society)
        cb('ok')
    end)
    
    -- RegisterNUICallback for deleting a society
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('deleteSociety', function(data, cb)
        society_management_callback_deleteSociety(data.society)
        cb('ok')
    end)
    
    -- RegisterNUICallback for editing a society
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('editSociety', function(data, cb)
        society_managment_callback_editSociety(data.society)
        cb('ok')
    end)
    
    -- RegisterNUICallback for withdrawing money from a society
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('withdrawSocietyMoney', function(data, cb)
        society_management_callback_withdrawSocietyMoney(data.society, data.amount)
        cb('ok')
    end)
    
    -- RegisterNUICallback for depositing money into a society
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('depositSocietyMoney', function(data, cb)
        society_management_callback_depositSocietyMoney(data.society, data.amount)
        cb('ok')
    end)
    
    -- RegisterNUICallback for setting the amount of money in a society
    -- @param data: The data received from the NUI callback
    -- @param cb: The callback function to send the response
    RegisterNUICallback('setSocietyMoney', function(data, cb)
        society_management_callback_setSocietyMoney(data.society, data.amount)
        cb('ok')
    end)
    