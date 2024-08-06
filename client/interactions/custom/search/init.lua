 while not InteractionsFunctions do
    Wait(1)
end

InteractionsFunctions["search"] = function()
    -- copied from  https://github.com/esx-framework/esx_policejob/blob/main/client/main.lua
    player = framework_GetClosestPlayer()
    OxInventory = GetResourceState('ox_inventory') == 'started'
        if OxInventory then
            ESX.CloseContext()
            exports.ox_inventory:openInventory('player', GetPlayerServerId(player))
            return
        end
    
        ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
            local elements = {
                {unselectable = true, icon = "fas fa-user", title = TranslateCap('search')}
            }
    
            for i=1, #data.accounts, 1 do
                if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
                    elements[#elements+1] = {
                        icon = "fas fa-money",
                        title    = TranslateCap('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
                        value    = 'black_money',
                        itemType = 'item_account',
                        amount   = data.accounts[i].money
                    }
                    break
                end
            end
    
            table.insert(elements, {label = TranslateCap('guns_label')})
    
            for i=1, #data.weapons, 1 do
                elements[#elements+1] = {
                    icon = "fas fa-gun",
                    title    = TranslateCap('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
                    value    = data.weapons[i].name,
                    itemType = 'item_weapon',
                    amount   = data.weapons[i].ammo
                }
            end
    
            elements[#elements+1] = {title = TranslateCap('inventory_label')}
    
            for i=1, #data.inventory, 1 do
                if data.inventory[i].count > 0 then
                    elements[#elements+1] = {
                        icon = "fas fa-box",
                        title    = TranslateCap('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
                        value    = data.inventory[i].name,
                        itemType = 'item_standard',
                        amount   = data.inventory[i].count
                    }
                end
            end
    
            ESX.OpenContext("right", elements, function(menu,element)
                local data = {current = element}
                if data.current.value then
                    TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
                    OpenBodySearchMenu(player)
                end
            end)
        end, GetPlayerServerId(player))
   
end

