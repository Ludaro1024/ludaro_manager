if Config.Menu == "NativeUI" then
function openBossMenu(data, jobName)
    local bossmenuData = getBossMenuData(jobName)
    local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 10.0)
    mainmenu = NativeUI.CreateMenu(Locale("bossmenu"), "")
    _menuPool:Add(mainmenu)
    _menuPool:RefreshIndex()
    _menuPool:MouseControlsEnabled(false)
    _menuPool:MouseEdgeEnabled(false)
    _menuPool:ControlDisablingEnabled(false)

    if next(bossmenuData.society) then
        local societySubMenu = _menuPool:AddSubMenu(mainmenu, Locale("society_money"), "")
        _menuPool:Add(mainmenu)
        _menuPool:RefreshIndex()
        _menuPool:MouseControlsEnabled(false)
        _menuPool:MouseEdgeEnabled(false)
        _menuPool:ControlDisablingEnabled(false)
        local societyMoneyItem = NativeUI.CreateItem(Locale("current_money") .. ": $" .. bossmenuData.society.money, "")
        societySubMenu:AddItem(societyMoneyItem)
        local depositMoneyItem = NativeUI.CreateItem(Locale("deposit_money"), "")
        depositMoneyItem.Activated = function(ParentMenu, SelectedItem)
            local amount = lib.inputDialog(Locale("deposit_money"), { Locale("amount") })
            if amount then
                depositSocietyMoney(jobname, tonumber(amount[1]))
                societyMoneyItem:RightLabel("$" .. bossmenuData.society.money + tonumber(amount[1]))
            end
        end
        societySubMenu:AddItem(depositMoneyItem)
        local withdrawMoneyItem = NativeUI.CreateItem(Locale("withdraw_money"), "")
        withdrawMoneyItem.Activated = function(ParentMenu, SelectedItem)
            local amount = lib.inputDialog(Locale("withdraw_money"), { Locale("amount") })
            if amount then
                withdrawSocietyMoney(jobname, tonumber(amount[1]))
                societyMoneyItem:RightLabel("$" .. bossmenuData.society.money - tonumber(amount[1]))
            end
        end
        societySubMenu:AddItem(withdrawMoneyItem)
    end

    if next(bossmenuData.grades) then
        local gradesSubMenu = _menuPool:AddSubMenu(mainmenu, Locale("grades"), "")
        _menuPool:RefreshIndex()
        _menuPool:MouseControlsEnabled(false)
        _menuPool:MouseEdgeEnabled(false)
        _menuPool:ControlDisablingEnabled(false)
        for _, grade in ipairs(bossmenuData.grades) do
            local gradeItem = NativeUI.CreateItem(grade.label, "")
            gradeItem:RightLabel("$" .. grade.salary)
            gradeItem.Activated = function(ParentMenu, SelectedItem)
                local salary = lib.inputDialog(Locale("set_salary"), { Locale("amount") })
                if salary then
                    setGradeSalary(jobname, grade.grade, tonumber(salary[1]))
                    gradeItem:RightLabel("$" .. tonumber(salary[1]))
                end
            end
            gradesSubMenu.SubMenu:AddItem(gradeItem)
        end
    end

    if next(bossmenuData.employees) then
        local employeesSubMenu = _menuPool:AddSubMenu(mainmenu, Locale("employees"), "")
        _menuPool:RefreshIndex()
        _menuPool:MouseControlsEnabled(false)
        _menuPool:MouseEdgeEnabled(false)
        _menuPool:ControlDisablingEnabled(false)
        for _, employee in ipairs(bossmenuData.employees) do
            print(ESX.DumpTable(employee))
            employeesinglesubmenu = _menuPool:AddSubMenu(employeesSubMenu.SubMenu, employee.firstname .. " " .. employee.lastname, "")
            _menuPool:RefreshIndex()
            _menuPool:MouseControlsEnabled(false)
            _menuPool:MouseEdgeEnabled(false)
            _menuPool:ControlDisablingEnabled(false)
            local gradeItem = NativeUI.CreateItem(Locale("grade") .. ": " .. employee.job_grade, "")
            employeesinglesubmenu.SubMenu:AddItem(gradeItem)
            local fireItem = NativeUI.CreateItem(Locale("fire"), "")
            fireItem.Activated = function(ParentMenu, SelectedItem)
                fireEmployee(jobname, employee.id)
                employeesSubMenu:RemoveItem(employeesinglesubmenu)
            end
            employeesinglesubmenu.SubMenu:AddItem(fireItem)
            promote = NativeUI.CreateItem(Locale("promote"), "")
            promote.Activated = function(ParentMenu, SelectedItem)
                local grades = {}
                for _, grade in ipairs(bossmenuData.grades) do
                    table.insert(grades, grade.label)
                end
                local selectedGrade = lib.selectDialog(Locale("select_grade"), grades)
                if selectedGrade then
                    employee.grade = selectedGrade
                    saveEmployee(employee)
                    gradeItem:RightLabel(selectedGrade)
                end
            end
            employeesinglesubmenu.SubMenu:AddItem(promote)
            demote = NativeUI.CreateItem(Locale("demote"), "")
            demote.Activated = function(ParentMenu, SelectedItem)
                local grades = {}
                for _, grade in ipairs(bossmenuData.grades) do
                    table.insert(grades, grade.label)
                end
                local selectedGrade = lib.selectDialog(Locale("select_grade"), grades)
                if selectedGrade then
                    employee.grade = selectedGrade
                    saveEmployee(employee)
                    gradeItem:RightLabel(selectedGrade)
                end
            end
        end

        if next(players) and #players > 1 then
            hirenearbysubmenu = _menuPool:AddSubMenu(employeesSubMenu.SubMenu, Locale("hire_nearby"), "")
            _menuPool:RefreshIndex()
            _menuPool:MouseControlsEnabled(false)
            _menuPool:MouseEdgeEnabled(false)
            _menuPool:ControlDisablingEnabled(false)

            for _, player in ipairs(players) do
                local playerPed = GetPlayerPed(player)
                local playerServerId = GetPlayerServerId(player)
                local playerCoords = GetEntityCoords(playerPed)
                local playerItem = NativeUI.CreateItem(GetPlayerName(player) .. " (" .. playerServerId .. ")", "")
                playerItem.Activated = function(ParentMenu, SelectedItem)
                    hirePlayer(jobname, playerServerId)
                end
            end
        end

        mainmenu:Visible(true)
    end
end
end