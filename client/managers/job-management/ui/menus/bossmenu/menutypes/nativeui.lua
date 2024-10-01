if Config.Menu == "NativeUI" then
    function openBossMenu(data, jobName)
        if _menuPool:IsAnyMenuOpen() then
            return
        end
        local bossmenuData = jobmenu_bossmenu_getBossMenuData(jobName)
        local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 10.0)
        local xPlayer = ESX.GetPlayerData()
        local playerGrade = xPlayer.job.grade
        local maxGrade = #bossmenuData.grades

        mainmenu = NativeUI.CreateMenu(Locale("bossmenu"), "")
        _menuPool:Add(mainmenu)
        _menuPool:RefreshIndex()
        _menuPool:MouseControlsEnabled(false)
        _menuPool:MouseEdgeEnabled(false)
        _menuPool:ControlDisablingEnabled(false)

        -- Society Management
        local societySubMenu = _menuPool:AddSubMenu(mainmenu, Locale("society_management"), "")
        _menuPool:RefreshIndex()
        _menuPool:MouseControlsEnabled(false)
        _menuPool:MouseEdgeEnabled(false)
        _menuPool:ControlDisablingEnabled(false)

        local societyMoneyItem = NativeUI.CreateItem(Locale("current_money"), "")
        societyMoneyItem:RightLabel("$" .. (bossmenuData and bossmenuData.society and bossmenuData.society.money or 0))
        societySubMenu.SubMenu:AddItem(societyMoneyItem)

        local depositMoneyItem = NativeUI.CreateItem(Locale("deposit_money"), "")
        depositMoneyItem.Activated = function(ParentMenu, SelectedItem)
            local amount = lib.inputDialog(Locale("deposit_money"), { Locale("amount") })
            if amount then
                local success = society_management_callback_depositSocietyMoney(jobName, tonumber(amount[1]))
                if success then
                    bossmenuData.society.money = bossmenuData.society.money + tonumber(amount[1])
                    societyMoneyItem:RightLabel("$" .. bossmenuData.society.money)
                end
            end
        end
        societySubMenu.SubMenu:AddItem(depositMoneyItem)

        local withdrawMoneyItem = NativeUI.CreateItem(Locale("withdraw_money"), "")
        withdrawMoneyItem.Activated = function(ParentMenu, SelectedItem)
            local amount = lib.inputDialog(Locale("withdraw_money"), { Locale("amount") })
            if amount then
                local success = society_management_callback_withdrawSocietyMoney(jobName, tonumber(amount[1]))
                if success then
                    bossmenuData.society.money = bossmenuData.society.money - tonumber(amount[1])
                    societyMoneyItem:RightLabel("$" .. bossmenuData.society.money)
                end
            end
        end
        societySubMenu.SubMenu:AddItem(withdrawMoneyItem)

        -- Employee Management
        local employeeSubMenu = _menuPool:AddSubMenu(mainmenu, Locale("employee_management"), "")
        _menuPool:RefreshIndex()
        _menuPool:MouseControlsEnabled(false)
        _menuPool:MouseEdgeEnabled(false)
        _menuPool:ControlDisablingEnabled(false)

        local function createEmployeeSubMenu(employee, index)
            local employeeSubSubMenu = _menuPool:AddSubMenu(employeeSubMenu.SubMenu, employee.firstname .. " " .. employee.lastname, "")
            _menuPool:RefreshIndex()
            _menuPool:MouseControlsEnabled(false)
            _menuPool:MouseEdgeEnabled(false)
            _menuPool:ControlDisablingEnabled(false)

            local gradeItem = NativeUI.CreateItem(Locale("grade"), "")
            gradeItem:RightLabel(tostring(employee.job_grade))
            employeeSubSubMenu.SubMenu:AddItem(gradeItem)

            local fireItem = NativeUI.CreateItem(Locale("fire"), "")
            fireItem.Activated = function(ParentMenu, SelectedItem)
                local edata = { jobName = jobName, employee = {job_grade = employee.job_grade, identifier = employee.identifier}, fire = true }
                job_management_callback_saveEmployee(edata)
                if employee.identifier == xPlayer.identifier then
                    _menuPool:CloseAllMenus()
                else
                    employeeSubMenu.SubMenu:RemoveItemAt(index - 1)
                end
            end
            fireItem:Enabled(employee.job_grade < playerGrade)
            employeeSubSubMenu.SubMenu:AddItem(fireItem)

            local promoteItem = NativeUI.CreateItem(Locale("promote"), "")
            local demoteItem = NativeUI.CreateItem(Locale("demote"), "")

            local function updatePromotionDemotionState()
                promoteItem:Enabled(employee.job_grade < playerGrade - 1 and employee.job_grade < maxGrade)
                demoteItem:Enabled(employee.job_grade > 0 and employee.job_grade < playerGrade)
            end

            promoteItem.Activated = function(ParentMenu, SelectedItem)
                if employee.job_grade < maxGrade and employee.job_grade < playerGrade - 1 then
                    employee.job_grade = employee.job_grade + 1
                    local edata = { jobName = jobName, employee = {job_grade = employee.job_grade, identifier = employee.identifier} }
                    job_management_callback_saveEmployee(edata)
                    gradeItem:RightLabel(tostring(employee.job_grade))
                    updatePromotionDemotionState()
                end
            end
            employeeSubSubMenu.SubMenu:AddItem(promoteItem)

            demoteItem.Activated = function(ParentMenu, SelectedItem)
                if employee.job_grade > 0 and employee.job_grade < playerGrade then
                    employee.job_grade = math.max(employee.job_grade - 1, 0)
                    local edata = { jobName = jobName, employee = {job_grade = employee.job_grade, identifier = employee.identifier} }
                    job_management_callback_saveEmployee(edata)
                    gradeItem:RightLabel(tostring(employee.job_grade))
                    updatePromotionDemotionState()
                end
            end
            employeeSubSubMenu.SubMenu:AddItem(demoteItem)

            updatePromotionDemotionState()
        end

        table.sort(bossmenuData.employees, function(a, b) return a.job_grade > b.job_grade end)
        for index, employee in ipairs(bossmenuData.employees) do
            createEmployeeSubMenu(employee, index)
        end

        if next(players) and #players > 1 then
            local hireNearbySubMenu = _menuPool:AddSubMenu(employeeSubMenu.SubMenu, Locale("hire_nearby"), "")
            _menuPool:RefreshIndex()
            _menuPool:MouseControlsEnabled(false)
            _menuPool:MouseEdgeEnabled(false)
            _menuPool:ControlDisablingEnabled(false)

            for _, player in ipairs(players) do
                local playerName = GetPlayerName(player)
                local playerServerId = GetPlayerServerId(player)
                local job, grade = jobmanagement_zones_npcs_getJobandGrade(playerServerId)

                if job ~= jobName then
                    local playerItem = NativeUI.CreateItem(playerName .. " (" .. playerServerId .. ")", "")
                    playerItem:RightLabel("Grade: " .. tostring(grade))
                    playerItem.Activated = function(ParentMenu, SelectedItem)
                        local newPlayerData = jobmenu_bossmenu_hirePlayer(jobName, playerServerId)
                        if newPlayerData then
                            table.insert(bossmenuData.employees, newPlayerData.employee)
                            table.sort(bossmenuData.employees, function(a, b) return a.job_grade > b.job_grade end)
                            createEmployeeSubMenu(newPlayerData.employee, #bossmenuData.employees)
                        end
                    end
                    hireNearbySubMenu.SubMenu:AddItem(playerItem)
                end
            end
        end

        -- Grade Management
        local gradeSubMenu = _menuPool:AddSubMenu(mainmenu, Locale("grade_management"), "")
        _menuPool:RefreshIndex()
        _menuPool:MouseControlsEnabled(false)
        _menuPool:MouseEdgeEnabled(false)
        _menuPool:ControlDisablingEnabled(false)

        for _, grade in ipairs(bossmenuData.grades) do
            local gradeItem = NativeUI.CreateItem(grade.label, "")
            gradeItem:RightLabel("$" .. grade.salary)
            gradeItem.Activated = function(ParentMenu, SelectedItem)
                if grade.grade < playerGrade or playerGrade == maxGrade then
                    local salary = lib.inputDialog(Locale("set_salary"), { Locale("amount") })
                    if salary then
                        jobmenu_bossmenu_setGradeSalary(jobName, grade.grade, tonumber(salary[1]))
                        grade.salary = tonumber(salary[1])
                        gradeItem:RightLabel("$" .. tonumber(salary[1]))
                    end
                end
            end
            gradeSubMenu.SubMenu:AddItem(gradeItem)
        end

        mainmenu:Visible(true)
    end
end
