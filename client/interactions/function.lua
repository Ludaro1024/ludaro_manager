--[[
    removeDoubleExistingValueInFirstKeyTable

    This function removes any duplicate entries in a table based on the value of the first key in each entry.
    It iterates through the table and compares the first key of each entry to identify and remove duplicates.

    @param firstKeyTable (table): A table where each entry is expected to have a first key to be compared for duplicates.

    @return table: Returns the modified table with duplicates removed.
]]
function removeDoubleExistingValueInFirstKeyTable(firstKeyTable)
    Debug(3, "Removing duplicates based on the first key from the provided table.")
    
    for k, v in pairs(firstKeyTable) do 
        for k2, v2 in pairs(firstKeyTable) do
            if v[1] == v2[1] and k ~= k2 then
                Debug(2, "Duplicate found. Removing entry with key: " .. k)
                table.remove(firstKeyTable, k)
            end
        end
    end

    Debug(3, "Duplicate removal complete. Returning modified table.")
    return firstKeyTable
end
