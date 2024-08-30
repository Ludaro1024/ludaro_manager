--[[
    Initialize Search Interaction

    This script initializes the search interaction for players. It waits for the InteractionFunctions to exist,
    then sets up the "search" function. The search function allows players to search other players and 
    access their inventory, weapons, and money.

    @return nil: This script does not return any values but initializes the search interaction.
]]

-- Wait for InteractionFunctions to exist
while not InteractionsFunctions do
    Debug(3, "Waiting for InteractionsFunctions to be initialized.")
    Wait(1)
end

Debug(3, "Initializing search interaction.")

InteractionsFunctions["search"] = function()
    Debug(3, "Search interaction triggered.")

    local player = framework_GetClosestPlayer()
    if not player then
        Debug(2, "No closest player found to search.")
        EditableFunctions.Notify("No players nearby to search.")
        return
    end

    local OxInventory = GetResourceState('ox_inventory') == 'started'
    if OxInventory then
        ESX.CloseContext()
        Debug(3, "Opening OxInventory for player ID: " .. GetPlayerServerId(player))
        exports.ox_inventory:openInventory('player', GetPlayerServerId(player))
        return
    end

    ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
        local elements = {
            {unselectable = true, icon = "fas fa-user", title = TranslateCap('search')}
        }

        -- Adding black money to elements
        for i = 1, #data.accounts, 1 do
            if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
                elements[#elements + 1] = {
                    icon = "fas fa-money",
                    title = TranslateCap('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
                    value = 'black_money',
                    itemType = 'item_account',
                    amount = data.accounts[i].money
                }
                break
            end
        end

        -- Adding weapons to elements
        table.insert(elements, {label = TranslateCap('guns_label')})
        for i = 1, #data.weapons, 1 do
            elements[#elements + 1] = {
                icon = "fas fa-gun",
                title = TranslateCap('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
                value = data.weapons[i].name,
                itemType = 'item_weapon',
                amount = data.weapons[i].ammo
            }
        end

        -- Adding inventory items to elements
        elements[#elements + 1] = {title = TranslateCap('inventory_label')}
        for i = 1, #data.inventory, 1 do
            if data.inventory[i].count > 0 then
                elements[#elements + 1] = {
                    icon = "fas fa-box",
                    title = TranslateCap('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
                    value = data.inventory[i].name,
                    itemType = 'item_standard',
                    amount = data.inventory[i].count
                }
            end
        end

        ESX.OpenContext("right", elements, function(menu, element)
            local data = {current = element}
            if data.current.value then
                Debug(3, "Confiscating item from player ID: " .. GetPlayerServerId(player))
                TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
                OpenBodySearchMenu(player)
            end
        end)
    end, GetPlayerServerId(player))
end

--[[
    UseInteraction

    This function triggers the specified interaction from the InteractionsFunctions table.

    @param name (string): The name of the interaction to be triggered.

    @return nil: This function does not return any values but triggers the specified interaction.
]]
function UseInteraction(name)
    if InteractionsFunctions[name] then
        Debug(3, "Using interaction: " .. name)
        InteractionsFunctions[name]()
    else
        Debug(2, "Interaction not found: " .. name)
    end
end
