-- Register NUI callback for toggling the UI visibility
RegisterNUICallback('ToggleUI', function(data, cb)
    -- Toggle the UI visibility
    ui_functions_showAndHideUI()
    
    -- Acknowledge the callback without returning any data
    cb(nil)
end)

-- Register NUI callback to get the current changelogs
RegisterNUICallback('GetChangelog', function(data, cb)
    -- Trigger the server callback to get changelogs
    lib.callback("ludaro_manager:getChangelog", false, function(changelogs)
        if changelogs then
            -- Send the changelogs back to the NUI (home.vue)
            cb({ changelogs = changelogs })
        else
            cb({ changelogs = nil })
        end
    end)
end)
