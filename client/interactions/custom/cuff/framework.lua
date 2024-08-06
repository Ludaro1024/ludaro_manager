function framework_GetClosestPlayer()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    print()
    if closestPlayer ~= -1 and closestDistance <= 3.0 and closestPlayer ~= PlayerPedId() then
        return closestPlayer
    end
end