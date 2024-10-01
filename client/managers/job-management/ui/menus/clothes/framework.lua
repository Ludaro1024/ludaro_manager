function job_management_clothes_changeClothes(clothes)
    
    TriggerEvent('skinchanger:loadSkin', clothes)
end

function job_management_clothes_getNormalSkin()
    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin)
        if skin ~= nil then
            TriggerEvent("skinchanger:loadSkin", skin)
            Wait(100)
        end
    end)

end