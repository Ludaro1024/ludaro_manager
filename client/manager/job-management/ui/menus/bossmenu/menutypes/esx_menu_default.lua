if Config.Menu == "esx_menu_default" then
    function openBossMenu(data, jobName)
        local bossmenuData = getBossMenuData(jobName)
        local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 10.0)
        local elements = {}

        -- Society money menu
        if next(bossmenuData.society) then
            table.insert(elements, {
                label = Locale("society_money"),
                unselectable = true,
                icon = "fas fa-info-circle",
            })

            table.insert(elements, {
                label = Locale("current_money") .. ": $" .. bossmenuData.society.money,
                icon = "fas fa-dollar-sign",
                disabled = true,
            })

            table.insert(elements, {
                label = Locale("deposit_money"),
                icon = "fas fa-arrow-down",
                value = 'deposit_money'
            })

            table.insert(elements, {
                label = Locale("withdraw_money"),
                icon = "fas fa-arrow-up",
                value = 'withdraw_money'
            })
        end

        -- Grades menu
        if next(bossmenuData.grades) then
            table.insert(elements, {
                label = Locale("grades"),
                unselectable = true,
                icon = "fas fa-info-circle",
            })

            for _, grade in ipairs(bossmenuData.grades) do
                table.insert(elements, {
                    label = grade.label .. " (" .. Locale("salary") .. ": $" .. grade.salary .. ")",
                    icon = "fas fa-chevron-right",
                    value = 'grade_' .. grade.grade
                })
            end
        end

        -- Employees menu
        if next(bossmenuData.employees) then
            table.insert(elements, {
                label = Locale("manage_employees"),
                unselectable = true,
                icon = "fas fa-info-circle",
            })

            for _, employee in ipairs(bossmenuData.employees) do
                table.insert(elements, {
                    label = employee.firstname ..
                    " " .. employee.lastname .. " - " .. Locale("grade") .. ": " .. employee.job_grade,
                    icon = "fas fa-user",
                    value = 'employee_' .. employee.identifier
                })
            end
        end

        -- Nearby players menu
        if next(players) and #players > 1 then
            table.insert(elements, {
                label = Locale("hire_nearby"),
                unselectable = true,
                icon = "fas fa-info-circle",
            })

            for _, player in ipairs(players) do
                local playerName = GetPlayerName(player)
                local playerServerId = GetPlayerServerId(player)

                table.insert(elements, {
                    label = playerName .. " (" .. playerServerId .. ")",
                    icon = "fas fa-user-plus",
                    value = 'hire_' .. playerServerId
                })
            end
        end

        -- Open the ESX menu
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_menu', {
            title    = Locale("bossmenu"),
            align    = 'center',
            elements = elements
        }, function(data, menu)
            local value = data.current.value

            if value == 'deposit_money' then
                local amount = lib.inputDialog(Locale("deposit_money"), { Locale("amount") })
                if amount then
                    depositSocietyMoney(jobName, tonumber(amount[1]))
                    openBossMenu(jobName) -- Refresh the menu
                end
            elseif value == 'withdraw_money' then
                local amount = lib.inputDialog(Locale("withdraw_money"), { Locale("amount") })
                if amount then
                    withdrawSocietyMoney(jobName, tonumber(amount[1]))
                    openBossMenu(jobName) -- Refresh the menu
                end
            elseif string.match(value, '^grade_') then
                local gradeIndex = tonumber(string.sub(value, 7))
                local salary = lib.inputDialog(Locale("set_salary"), { Locale("amount") })
                if salary then
                    setGradeSalary(jobName, gradeIndex, tonumber(salary[1]))
                    openBossMenu(jobName) -- Refresh the menu
                end
            elseif string.match(value, '^employee_') then
                local employeeId = string.sub(value, 10)
                manageEmployeeMenu(jobName, employeeId, bossmenuData) -- Open employee management menu
            elseif string.match(value, '^hire_') then
                local playerServerId = tonumber(string.sub(value, 6))
                hirePlayer(jobName, playerServerId)
                openBossMenu(jobName) -- Refresh the menu
            end
        end, function(data, menu)
            menu.close()
        end)
    end

    -- Function to manage individual employee
    function manageEmployeeMenu(jobName, employeeId, bossmenuData)
        local employee = nil
        for _, emp in ipairs(bossmenuData.employees) do
            if emp.identifier == employeeId then
                employee = emp
                break
            end
        end

        if not employee then return end

        local employeeMenuElements = {
            { label = Locale("grade") .. ": " .. employee.job_grade, disabled = true },
            { label = Locale("fire"),                                icon = "fas fa-times",      value = 'fire' },
            { label = Locale("promote"),                             icon = "fas fa-arrow-up",   value = 'promote' },
            { label = Locale("demote"),                              icon = "fas fa-arrow-down", value = 'demote' }
        }

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'employee_menu', {
            title    = employee.firstname .. " " .. employee.lastname,
            align    = 'center',
            elements = employeeMenuElements
        }, function(data, menu)
            local value = data.current.value

            if value == 'fire' then
                fireEmployee(jobName, employee.id)
                menu.close()
                openBossMenu(jobName) -- Refresh the menu
            elseif value == 'promote' or value == 'demote' then
                local grades = {}
                for _, grade in ipairs(bossmenuData.grades) do
                    table.insert(grades, grade.label)
                end
                local selectedGrade = lib.selectDialog(Locale("select_grade"), grades)
                if selectedGrade then
                    employee.grade = selectedGrade
                    saveEmployee(employee)
                    menu.close()
                    openBossMenu(jobName) -- Refresh the menu
                end
            end
        end, function(data, menu)
            menu.close()
        end)
    end
end
