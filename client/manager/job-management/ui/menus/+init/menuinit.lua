function openMenu(data, jobname)
    opentype = data.openType

  if opentype == "bossmenu" then
    openBossMenu(data, jobname)
  end

  if opentype == "garagee" then
    openGarageMenu(data, jobname)
  end
end