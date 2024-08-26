-- Function to compare two version strings
local function compareVersions(version1, version2)
    local v1_parts = {}
    local v2_parts = {}

    -- Split version strings into parts
    for part in string.gmatch(version1, "%d+") do
        table.insert(v1_parts, tonumber(part))
    end
    for part in string.gmatch(version2, "%d+") do
        table.insert(v2_parts, tonumber(part))
    end

    -- Compare each part (major, minor, patch)
    for i = 1, math.max(#v1_parts, #v2_parts) do
        local v1 = v1_parts[i] or 0
        local v2 = v2_parts[i] or 0
        if v1 > v2 then
            return "higher"
        elseif v1 < v2 then
            return "lower"
        end
    end

    return "current"  -- Versions are equal
end

-- Example usage
local currentVersion = "1.0.0"

RegisterNUICallback('getChangelog', function(data, cb)
    local changelog = {
        { id = 1, version = "1.1.0", date = '2024-08-27', description = 'Added new vehicle management features.' },
        { id = 2, version = "1.0.0", date = '2024-08-20', description = 'Improved job creation interface.' },
        { id = 3, version = "0.9.0", date = '2024-08-15', description = 'Initial release.' }
    }

    -- Compare each changelog version with the current version
    for i, log in ipairs(changelog) do
        log.comparison = compareVersions(log.version, currentVersion)
    end

    cb(json.encode(changelog))
end)


RegisterNUICallback('getChangelogDetails', function(data, cb)
    local id = data.id
    -- Replace with actual logic to fetch details from a database
    local details = {
        [1] = { version = "1.1.0", date = '2024-08-27', details = 'Details of vehicle management features...' },
        [2] = { version = "1.0.0", date = '2024-08-20', details = 'Details of improved job creation interface...' },
        [3] = { version = "0.9.0", date = '2024-08-15', details = 'Initial release details...' }
    }

    if details[id] then
        cb(json.encode(details[id]))
    else
        cb(json.encode({ error = 'Changelog details not found.' }))
    end
end)
