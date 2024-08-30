-- Function to retrieve all farming spots from the database
function farming_management_getFarmingSpotsFromDB()
    local query = [[
        SELECT * FROM ludaro_manager_farmingspots;
    ]]
    local spots = MySQL.query.await(query)
    return spots or {}
end

-- Function to save or update a farming spot in the database
function farming_management_saveFarmingSpotToDB(farmingSpot)
    if farmingSpot.id then
        -- Update existing farming spot
        local query = [[
            UPDATE ludaro_manager_farmingspots
            SET
                name = @name,
                coords = @coords,
                job = @job,
                grade = @grade,
                animation = @animation,
                time = @time,
                progressbar = @progressBar,
                items_in = @itemsIn,
                items_out = @itemsOut,
                money_required = @moneyNeeded,
                money_type = @moneyType,
                society_name = @society,
                society_percentage = @societyPercentage,
                custom_code = @customCode,
                multi_step = @multiLocation
            WHERE id = @id;
        ]]
        if farmingSpot.moneyNeeded == nil or farmingSpot.moneyNeeded == "" then
            farmingSpot.moneyNeeded = 0
        end
        MySQL.query.await(query, {
            ['@id'] = farmingSpot.id,
            ['@name'] = farmingSpot.name,
            ['@coords'] = json.encode(farmingSpot.coords),
            ['@job'] = farmingSpot.job,
            ['@grade'] = farmingSpot.grade,
            ['@animation'] = farmingSpot.animation,
            ['@time'] = farmingSpot.time,
            ['@progressBar'] = farmingSpot.progressBar,
            ['@itemsIn'] = json.encode(farmingSpot.itemsIn),
            ['@itemsOut'] = json.encode(farmingSpot.itemsOut),
            ['@moneyNeeded'] = farmingSpot.moneyNeeded or 0,
            ['@moneyType'] = farmingSpot.moneyType,
            ['@society'] = farmingSpot.society,
            ['@societyPercentage'] = farmingSpot.societyPercentage,
            ['@customCode'] = farmingSpot.customCode,
            ['@multiLocation'] = farmingSpot.multiLocation
        })
    else
        -- Insert new farming spot
        local query = [[
            INSERT INTO ludaro_manager_farmingspots (
                name, coords, job, grade, animation, time, progressbar, items_in, items_out, money_required, money_type, society_name, society_percentage, custom_code, multi_step
            ) VALUES (
                @name, @coords, @job, @grade, @animation, @time, @progressBar, @itemsIn, @itemsOut, @moneyNeeded, @moneyType, @society, @societyPercentage, @customCode, @multiLocation
            );
        ]]
        MySQL.query.await(query, {
            ['@name'] = farmingSpot.name,
            ['@coords'] = json.encode(farmingSpot.coords),
            ['@job'] = farmingSpot.job,
            ['@grade'] = farmingSpot.grade,
            ['@animation'] = farmingSpot.animation,
            ['@time'] = farmingSpot.time,
            ['@progressBar'] = farmingSpot.progressBar,
            ['@itemsIn'] = json.encode(farmingSpot.itemsIn),
            ['@itemsOut'] = json.encode(farmingSpot.itemsOut),
            ['@moneyNeeded'] = farmingSpot.moneyNeeded,
            ['@moneyType'] = farmingSpot.moneyType,
            ['@society'] = farmingSpot.society,
            ['@societyPercentage'] = farmingSpot.societyPercentage,
            ['@customCode'] = farmingSpot.customCode,
            ['@multiLocation'] = farmingSpot.multiLocation
        })
    end
    return true
end

-- Function to get all jobs from the database
function farming_management_getJobsFromDB()
    local query = [[
        SELECT name, label FROM jobs;
    ]]
    local jobs = MySQL.query.await(query)
    return jobs or {}
end

-- Function to get all animations from the database or predefined list
function farming_management_getAnimationsFromDB()
    -- Assuming animations are stored in a predefined table or file
    local animations = {
        { name = "WORLD_HUMAN_AA_COFFEE", label = "Drink Coffee" },
        { name = "WORLD_HUMAN_BINOCULARS", label = "Use Binoculars" },
        -- Add more animations here...
    }
    return animations
end

-- Function to get all societies from the database
function farming_management_getSocietiesFromDB()
    local query = [[
        SELECT
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
    local societies = MySQL.query.await(query)
    return societies or {}
end


