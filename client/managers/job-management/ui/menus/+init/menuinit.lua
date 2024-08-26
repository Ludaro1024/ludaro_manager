function openMenu(data, jobname)
    opentype = data.openType
    
  
  if opentype == "bossmenu" then
    openBossMenu(data, jobname)
  end
  if opentype == "garage" then
    openGarageMenu(data, jobname)
  end
  if opentype == "vehicleShop" then
    openVehicleShopMenu(data, jobname)
  end
  if opentype == "onoffduty" then
    openOnOffDutyMenu(data, jobname)
  end
  if opentype == "clothes" then
    openClothesMenu(data, jobname)
  end

  if opentype == "stashes" then
    EditableFunctions.OpenStash(data, jobname)
  end
end