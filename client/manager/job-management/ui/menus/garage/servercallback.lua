function garage_getGarageData()
    return lib.callback.await("ludaro_manager:getGarageData", false)
end

function garage_parkin(vehicle)
    return lib.callback.await("ludaro_manager:parkin", false, vehicle)
end

function garage_parkout(plate)
    return lib.callback.await("ludaro_manager:parkout", false, {plate = plate})
end