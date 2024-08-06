function IsCuffed(id)
  xPlayer = ESX.GetPlayerFromId(id)
  if xPlayer then
    return xPlayer.get('cuff')
  end
end

function setCuffed(id, bool)
    xPlayer = ESX.GetPlayerFromId(id)
    if xPlayer then
        xPlayer.set('cuff', bool)
    end
end