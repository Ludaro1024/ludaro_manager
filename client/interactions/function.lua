function removeDoubleExistingValueInFirstKeyTable(firstKeyTable)
    for k,v in pairs(firstKeyTable) do 
        for k2,v2 in pairs(firstKeyTable) do
            if v[1] == v2[1] and k ~= k2 then
                table.remove(firstKeyTable, k)
            end
        end
    end
    return firstKeyTable
end