function garage_getGarageData()
    return lib.callback.await("ludaro_manager:getGarageData", false)
end

function garage_parkin(vehicle)
    return lib.callback.await("ludaro_manager:parkin", false, vehicle)
end

function garage_parkout(vehicle)
    return lib.callback.await("ludaro_manager:parkout", false, vehicle)
end

function garage_isOwned(plate)
    return lib.callback.await("ludaro_manager:isOwned", false, plate)
end