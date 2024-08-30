--[[
    IsCuffed

    This function checks whether a player is currently cuffed by querying their ESX player data.

    @param id (number): The server ID of the player to check cuff status for.

    @return boolean: Returns true if the player is cuffed, false otherwise.
]]
function IsCuffed(id)
  xPlayer = ESX.GetPlayerFromId(id)
  if xPlayer then
      Debug(3, "Checking cuff status for player: " .. id)
      return xPlayer.get('cuff')
  end
  Debug(2, "Player not found for cuff status check: " .. id)
  return false
end

--[[
  setCuffed

  This function sets the cuffed status of a player in their ESX player data.

  @param id (number): The server ID of the player to set the cuff status for.
  @param bool (boolean): The cuff status to set (true for cuffed, false for uncuffed).

  @return nil: This function does not return any values but updates the player's cuff status.
]]
function setCuffed(id, bool)
  xPlayer = ESX.GetPlayerFromId(id)
  if xPlayer then
      Debug(3, "Setting cuff status for player " .. id .. " to " .. tostring(bool))
      xPlayer.set('cuff', bool)
  else
      Debug(2, "Player not found to set cuff status: " .. id)
  end
end
