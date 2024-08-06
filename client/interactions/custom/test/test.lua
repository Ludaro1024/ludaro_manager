-- wait for IntneractionFunctions to exist
while not InteractionsFunctions do
    Wait(1)
end

InteractionsFunctions["test"] = function()
    -- your code for testing
    print("Yay")
end