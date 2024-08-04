-- TODO: add Nil checks
function getSocieties()
    if ESX then
        -- get all societies from addon_account where shared = 1 and add money  to it from  addon_account_adata where name = @name from addon_account and the inventory from addon_incnentory and owner if one exists, and the
        query     = [[SELECT
    a.name,
    a.label,
    COALESCE(ad.money, 0) AS money
FROM
    addon_account a
LEFT JOIN
    addon_account_data ad ON a.name = ad.account_name
WHERE
    a.shared = 1;
]]
        societies = MySQL.query.await(query)
        return societies
    end
end

function getSociety(jobName)

    if string.find(jobName, "society_") then
        jobname = jobName
    else
        jobname = "society_" .. jobName
    end

    if ESX then
        -- LIKE NAME
        query = [[SELECT
    a.name,
    a.label,
    COALESCE(ad.money, 0) AS money
FROM
    addon_account a
LEFT JOIN
    addon_account_data ad ON a.name = ad.account_name
WHERE
    a.name = @name AND a.shared = 1 LIMIT 1;
]]
        society = MySQL.query.await(query, { ['@name'] = jobname })
        return society[1]
    end
end

function deleteSociety(society)
    if ESX then
        query = [[DELETE FROM addon_account WHERE name = @name;]]
        MySQL.query.await(query, { ['@name'] = society.name })
        query = [[DELETE FROM addon_account_data WHERE account_name = @name;]]
        MySQL.query.await(query, { ['@name'] = society.name })
        query = [[DELETE FROM addon_inventory WHERE owner = @name;]]
        MySQL.query.await(query, { ['@name'] = society.name })
        return true
    end
end

function addSociety(society)
    if ESX and not doesSocietyExist(society) then
        query = [[INSERT INTO addon_account (name, label, shared) VALUES (@name, @label, 1);]]
        MySQL.query.await(query, { ['@name'] = society.name, ['@label'] = society.label })
        query = [[INSERT INTO addon_account_data (account_name, money) VALUES (@name, 0);]]
        MySQL.query.await(query, { ['@name'] = society.name })
        return getSociety(society.name)
    end
end

function editSociety(society)
    if ESX and next(society) and doesSocietyExist(society) then
        query = [[UPDATE addon_account SET label = @label WHERE name = @name;]]
        MySQL.query.await(query, { ['@name'] = society.name, ['@label'] = society.label })
        return true
    end
end

function withdrawSocietyMoney(society, amount, source)
    if ESX  and doesSocietyExist(society) then
            addMoney(source, amount)
        query = [[UPDATE addon_account_data SET money = money - @amount WHERE account_name = @name;]]
        MySQL.query.await(query, { ['@name'] = society.name, ['@amount'] = amount })
        return true
        end
end

function depositSocietyMoney(society, amount, source)
    if ESX  and doesSocietyExist(society) and hasEnoughMoney(source, amount) then
        withdrawMoney(source, amount)
        query = [[UPDATE addon_account_data SET money = money + @amount WHERE account_name = @name;]]
        MySQL.query.await(query, { ['@name'] = society.name, ['@amount'] = amount })
        return true
    else
        showNotification(source, Locale("not_enough_money"))
        return false
end
end

function setSocietyMoney(society, amount)
    if ESX  and next(society)  and doesSocietyExist(society?.name) then
        query = [[UPDATE addon_account_data SET money = @amount WHERE account_name = @name;]]
        MySQL.query.await(query, { ['@name'] = society.name, ['@amount'] = amount })
        return true
    end
end

function doesSocietyExist(society)
    
    if type(society) == "table" then
        societyName = society.name
    elseif type(society) == "string" then
        if string.find(society, "society_") then
            societyName = society
        else
            societyName = "society_" .. society
        end
    else
        return false
    end
    if ESX then
        query = [[SELECT name FROM addon_account WHERE name = @name;]]
        result = MySQL.query.await(query, { ['@name'] = societyName })
        return next(result) and true or false
    end
    return false
end