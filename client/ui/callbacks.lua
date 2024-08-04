function ui_callbacks_getAllowed()
    return lib.callback.await('ludaro_manager:getAllowed', false)
end