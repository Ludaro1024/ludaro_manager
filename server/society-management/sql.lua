function getSocieties()
    if ESX then 
        -- get all societies from addon_account where shared = 1 and add money  to it from  addon_account_adata where name = @name from addon_account and the inventory from addon_incnentory and owner if one exists, and the 
        query = [[SELECT
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
        societies  = MySQL.query.await(query) 
       return societies
    end
end