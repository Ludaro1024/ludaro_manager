
--[[
    framework_checkFrameworkVersion

    This function checks if the ESX version is 1.2 or higher.
    If the ESX version is lower than 1.2, the script will throw an error.
]]

function frameworkcheck_checkFrameworkVersion()
    Debug(3, "Starting ESX version check.")

    -- Get ESX shared object and version
    ESX = exports['es_extended']:getSharedObject()
    ESXversion = GetResourceMetadata("es_extended", 'version', 0)

    -- Function to compare two version strings
    function compareVersion(version1, version2)
        local v1 = {}
        for num in string.gmatch(version1, "[^.]+") do
            table.insert(v1, tonumber(num))
        end

        local v2 = {}
        for num in string.gmatch(version2, "[^.]+") do
            table.insert(v2, tonumber(num))
        end

        local maxLength = math.max(#v1, #v2)
        for i = 1, maxLength do
            local num1 = v1[i] or 0
            local num2 = v2[i] or 0
            if num1 < num2 then
                return -1
            elseif num1 > num2 then
                return 1
            end
        end
        return 0
    end

    -- Compare the ESX version with the required version
    local compareResult = compareVersion(ESXversion, "1.10.1")
    local compareResultExact = compareVersion(ESXversion, "1.2")

    if compareResult <= 0 or compareResultExact == 0 then
        Debug(1, "ESX version is not 1.2 or higher.")
        error('ESX VERSION IS NOT 1.2 OR HIGHER. PLEASE UPDATE YOUR ESX VERSION OR FIX IT | Your ESX Version IS: ' .. ESXversion)
    else
        Debug(2, "ESX version is 1.2 or higher.")
    end

    if ESX == nil then
        Debug(1, "ESX shared object was not found.")
        error('ESX WAS NOT FOUND. PLEASE UPDATE YOUR ESX VERSION OR FIX IT.')
    else
        Debug(2, "ESX shared object was successfully retrieved.")
    end
end

-- Execute the framework version check
frameworkcheck_checkFrameworkVersion()
