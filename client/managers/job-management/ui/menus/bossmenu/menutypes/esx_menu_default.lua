if Config.Menu == "esx_menu_default" then
    function openBossMenu(data, jobName)
        local bossmenuData = jobmenu_bossmenu_getBossMenuData(jobName)
        local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 10.0)
        local xPlayer = ESX.GetPlayerData()
        local playerGrade = xPlayer.job.grade

        local elements = {
            {label = Locale("society_management"), icon = "fas fa-info-circle", value = 'society'},
            {label = Locale("employee_management"), icon = "fas fa-user", value = 'employees'},
            {label = Locale("grade_management"), icon = "fas fa-sitemap", value = 'grades'}
        }

        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_menu', {
            title = Locale("bossmenu"),
            align = 'center',
            elements = elements
        }, function(data, menu)
            local value = data.current.value
            if value == 'society' then
                bossmenuData.society.money = (bossmenuData and bossmenuData.society and bossmenuData.society.money or 0)
                openSocietyMenu(bossmenuData.society, jobName)
            elseif value == 'employees' then
                openEmployeeMenu(bossmenuData.employees, jobName, players, bossmenuData.grades, playerGrade)
            elseif value == 'grades' then
                openGradeMenu(bossmenuData.grades, jobName, playerGrade)
            end
        end, function(data, menu)
            menu.close()
        end)
    end

    function openSocietyMenu(societyData, jobName)
        local elements = {
            {label = Locale("current_money") .. ": $" .. societyData.money, icon = "fas fa-dollar-sign", disabled = true},
            {label = Locale("deposit_money"), icon = "fas fa-arrow-down", value = 'deposit_money'},
            {label = Locale("withdraw_money"), icon = "fas fa-arrow-up", value = 'withdraw_money'}
        }

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'society_menu', {
            title = Locale("society_management"),
            align = 'center',
            elements = elements
        }, function(data, menu)
            local value = data.current.value
            if value == 'deposit_money' then
                local amount = lib.inputDialog(Locale("deposit_money"), {Locale("amount")})
                if amount and amount[1] and tonumber(amount[1]) > 0 then
                    local success = society_management_callback_depositSocietyMoney(jobName, tonumber(amount[1]))
                    if success then
                        societyData.money = societyData.money + tonumber(amount[1])
                        openSocietyMenu(societyData, jobName)
                    end
                end
            elseif value == 'withdraw_money' then
                local amount = lib.inputDialog(Locale("withdraw_money"), {Locale("amount")})
                if amount and amount[1] and tonumber(amount[1]) > 0 then
                    local success = society_management_callback_withdrawSocietyMoney(jobName, tonumber(amount[1]))
                    if success then
                        societyData.money = societyData.money - tonumber(amount[1])
                        openSocietyMenu(societyData, jobName)
                    end
                end
            end
        end, function(data, menu)
            menu.close()
        end)
    end

    function openEmployeeMenu(employeeData, jobName, players, gradeData, playerGrade)
        local elements = {}

        for _, employee in ipairs(employeeData) do
            table.insert(elements, {
                label = employee.firstname .. " " .. employee.lastname .. " - " .. Locale("grade") .. ": " .. employee.job_grade,
                icon = "fas fa-user",
                value = 'employee_' .. employee.identifier
            })
        end

        if type(players) == "table" and #players > 0 then    
            table.insert(elements, {
                label = Locale("hire_nearby"),
                unselectable = true,
                icon = "fas fa-info-circle",
            })

            for _, player in ipairs(players) do
                local playerName = GetPlayerName(player)
                local playerServerId = GetPlayerServerId(player)
                local job, grade = jobmanagement_zones_npcs_getJobandGrade(playerServerId)

                if job ~= jobName then
                    table.insert(elements, {
                        label = playerName .. " (" .. playerServerId .. ")",
                        icon = "fas fa-user-plus",
                        value = 'hire_' .. playerServerId
                    })
                end
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'employee_menu', {
            title = Locale("employee_management"),
            align = 'center',
            elements = elements
        }, function(data, menu)
            local value = data.current.value
            if string.match(value, '^employee_') then
                local employeeId = string.sub(value, 10)
                manageEmployeeMenu(jobName, employeeId, employeeData, gradeData, playerGrade, menu)
            elseif string.match(value, '^hire_') then
                local playerServerId = tonumber(string.sub(value, 6))
                local newPlayerData = jobmenu_bossmenu_hirePlayer(jobName, playerServerId)
                if newPlayerData then
                    table.insert(employeeData, newPlayerData.employee)
                    menu.close()
                    openEmployeeMenu(employeeData, jobName, players, gradeData, playerGrade)
                end
            end
        end, function(data, menu)
            menu.close()
        end)
    end

    function openGradeMenu(gradeData, jobName, playerGrade)
        local elements = {}

        for _, grade in ipairs(gradeData) do
            table.insert(elements, {
                label = grade.label .. " (" .. Locale("salary") .. ": $" .. grade.salary .. ")",
                icon = "fas fa-chevron-right",
                value = 'grade_' .. grade.grade
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'grade_menu', {
            title = Locale("grade_management"),
            align = 'center',
            elements = elements
        }, function(data, menu)
            local value = data.current.value
            if string.match(value, '^grade_') then
                local gradeIndex = tonumber(string.sub(value, 7))
                if gradeIndex < playerGrade then
                    local salary = lib.inputDialog(Locale("set_salary"), {Locale("amount")})
                    if salary and salary[1] and tonumber(salary[1]) > 0 then
                        jobmenu_bossmenu_setGradeSalary(jobName, gradeIndex, tonumber(salary[1]))
                        gradeData[gradeIndex + 1].salary = tonumber(salary[1])
                        menu.close()
                        openGradeMenu(gradeData, jobName, playerGrade)
                    end
                end
            end
        end, function(data, menu)
            menu.close()
        end)
    end

    function manageEmployeeMenu(jobName, employeeId, employeeData, gradeData, playerGrade, parentMenu)
        local employee = nil
        for _, emp in ipairs(employeeData) do
            if emp.identifier == employeeId then
                employee = emp
                break
            end
        end

        if not employee then return end

        local employeeMenuElements = {
            { label = Locale("grade") .. ": " .. employee.job_grade, disabled = true },
            { label = Locale("fire"), icon = "fas fa-times", value = 'fire', enabled = employee.job_grade < playerGrade },
            { label = Locale("promote"), icon = "fas fa-arrow-up", value = 'promote', enabled = employee.job_grade < playerGrade - 1 and employee.job_grade < #gradeData },
            { label = Locale("demote"), icon = "fas fa-arrow-down", value = 'demote', enabled = employee.job_grade > 0 and employee.job_grade < playerGrade }
        }

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'employee_manage_menu', {
            title = employee.firstname .. " " .. employee.lastname,
            align = 'center',
            elements = employeeMenuElements
        }, function(data, menu)
            local value = data.current.value

            if value == 'fire' then
                local edata = { jobName = employee.job, employee = {job_grade = employee.job_grade, identifier = employee.identifier}, fire = true }
                job_management_callback_saveEmployee(edata)
                ESX.UI.Menu.CloseAll()
                openEmployeeMenu(employeeData, jobName, players, gradeData, playerGrade)
            elseif value == 'promote' or value == 'demote' then
                if value == 'promote' and employee.job_grade < playerGrade - 1 and employee.job_grade < #gradeData then
                    employee.job_grade = employee.job_grade + 1
                elseif value == 'demote' and employee.job_grade > 0 and employee.job_grade < playerGrade then
                    employee.job_grade = employee.job_grade - 1
                end
                local edata = { jobName = employee.job, employee = {job_grade = employee.job_grade, identifier = employee.identifier} }
                job_management_callback_saveEmployee(edata)
                menu.close()
                parentMenu.close()
                openEmployeeMenu(employeeData, jobName, players, gradeData, playerGrade)
            end
        end, function(data, menu)
            menu.close()
        end)
    end
end
