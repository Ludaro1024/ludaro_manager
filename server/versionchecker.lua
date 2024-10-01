local repo = GetResourceMetadata(GetCurrentResourceName(), "github", 0) or "https://github.com/Ludaro1024/LudaroVersionChecker"
local scriptname = GetResourceMetadata(GetCurrentResourceName(), "name", 0) or GetCurrentResourceName()
local currentversion = tonumber(GetResourceMetadata(GetCurrentResourceName(), "version"))

if not repo or not scriptname or not currentversion then
    print("Error: Missing metadata in fxmanifest.")
    return
end

-- Extract owner and repo name from the GitHub URL
local owner, repoName = repo:match("https://github.com/([^/]+)/([^/]+)")

if not owner or not repoName then
    print("Error: Invalid GitHub repository URL.")
    return
end

-- Function to retrieve changelog for a specific version with return
function getChangelogForVersion(version)
    local changelogUrl = "https://raw.githubusercontent.com/" .. owner .. "/" .. repoName .. "/main/" .. scriptname .. "/" .. version .. ".json"
    local result, isFinished = nil, false
    
    PerformHttpRequest(changelogUrl, function(statusCode, response, headers)
        if statusCode == 200 then
            local data = json.decode(response)
            result = data or nil -- Return data if valid, else nil
        else
            result = nil -- HTTP request failed
        end
        isFinished = true
    end, "GET", "", {["Content-Type"] = "application/json"})

    -- Wait until the request is finished
    while not isFinished do
        Wait(0)
    end

    return result
end

-- Function to get changelogs for all versions, including versions below and one above if outdated, with return
function getAllChangelogs()
    local changelogs = {}
    local version = currentversion

    -- Check versions below the current version
    while version >= 0 do
        local changelog = getChangelogForVersion(version)
        if changelog then
            table.insert(changelogs, changelog)
        end
        version = version - 1
    end

    -- Check one version above the current version (for the latest version if outdated)
    local aboveVersion = getChangelogForVersion(currentversion + 1)
    if aboveVersion then
        table.insert(changelogs, aboveVersion)
    end

    return changelogs
end

-- Register callback to fetch all changelogs (now using return, not callback)
lib.callback.register("ludaro_manager:getChangelog", function(source)
    local changelogs = getAllChangelogs()
    return changelogs
end)

-- Function to perform the HTTP request and check for updates (no change here)
function checkVersion()
    local url = "https://api.github.com/repos/" .. owner .. "/" .. repoName .. "/contents/" .. scriptname
    local highestVersion = currentversion
    local versionFiles = {}

    PerformHttpRequest(url, function(statusCode, response, headers)
        if statusCode == 200 then
            local files = json.decode(response)
            if files and type(files) == "table" then
                for _, file in ipairs(files) do
                    local version = tonumber(file.name:match("(%d+%.%d+)%.json$"))
                    if version then
                        table.insert(versionFiles, version)
                    end
                end

                -- Find the highest version
                for _, version in ipairs(versionFiles) do
                    if version > highestVersion then
                        highestVersion = version
                    end
                end

                if highestVersion > currentversion then
                    local updateUrl = "https://raw.githubusercontent.com/" .. owner .. "/" .. repoName .. "/main/" .. scriptname .. "/" .. highestVersion .. ".json"
                    PerformHttpRequest(updateUrl, function(updateStatusCode, updateResponse, updateHeaders)
                        if updateStatusCode == 200 then
                            local data = json.decode(updateResponse)
                            if data then
                                print("Update available for " .. scriptname .. ":")
                                print("  Current version: " .. currentversion)
                                print("  Latest version: " .. highestVersion)
                                print("  Changed files: " .. data.changed_files)
                                print("  Changelog: " .. data.changelog)
                                print("  Date: " .. data.date)
                            else
                                print("^1Error: Invalid update details format.^0")
                            end
                        else
                            print("^1Error: Failed to retrieve update details. HTTP Status Code: " .. updateStatusCode .. "^0")
                        end
                    end, "GET", "", {["Content-Type"] = "application/json"})
                else
                    print("^2[Ludaro-Manager]^0 | ^0You are using the latest version (" .. currentversion .. ") of " .. scriptname .. ". and are up to date!^0")
                end
            else
                print("^1Error: Invalid response format from directory listing.^0")
            end
        else
            print("^1Error: Failed to list directory contents. HTTP Status Code: " .. statusCode .. "^0")
        end
    end, "GET", "", {["Content-Type"] = "application/json"})
end

-- Initial check for updates
checkVersion()

