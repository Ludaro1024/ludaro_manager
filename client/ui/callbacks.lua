-- ui_callbacks_getAllowed
-- used to get the allowance status of a user
-- @return boolean The allowance status.
function ui_callbacks_getAllowed()
    return lib.callback.await('ludaro_manager:getAllowed', false)
end

function ui_callbacks_getChangelog()
    changelog = lib.callback.await("ludaro_manager:getChangelog", false)
    return changelog
end
