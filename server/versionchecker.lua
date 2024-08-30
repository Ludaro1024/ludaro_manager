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

-- Function to perform the HTTP request and check for updates
local function checkVersion()
    local url = "https://api.github.com/repos/" .. owner .. "/" .. repoName .. "/contents/" .. scriptname

    PerformHttpRequest(url, function(statusCode, response, headers)
        if statusCode == 200 then
            local highestVersion = currentversion
            local versionFiles = {}

            local files = json.decode(response)
            if files and type(files) == "table" then
                for _, file in ipairs(files) do
                    local version = tonumber(file.name:match("(%d+)%.json$"))
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
                    print("^2[Ludaro-Manager]^0 | ^0You are using the latest " .. "version" ..  " (" .. currentversion ..  ") of " .. scriptname .. ". and are up to date!^0" )
                end
            else
                print("^1Error: Invalid response format from directory listing.^0")
            end
        else
            print("^1Error: Failed to list directory contents. HTTP Status Code: " .. statusCode .. "^0")
        end
    end, "GET", "", {["Content-Type"] = "application/json"})
end

-- Call the function to check the version
checkVersion()
-- from  https://github.com/Ludaro1024/LudaroVersionChecker/blob/main/versionchecker.lua



