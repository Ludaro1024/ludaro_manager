--[[
    Initialize Test Interaction

    This script initializes a test interaction for players. It waits for the InteractionFunctions to exist,
    then sets up the "test" function for testing purposes.

    @return nil: This script does not return any values but initializes the test interaction.
]]

-- Wait for InteractionFunctions to exist
while not InteractionsFunctions do
    Debug(3, "Waiting for InteractionFunctions to be initialized.")
    Wait(1)
end

Debug(3, "Initializing test interaction.")

InteractionsFunctions["test"] = function()
    -- Your code for testing
    Debug(3, "Test interaction triggered.")
    -- Add your test code here
end
