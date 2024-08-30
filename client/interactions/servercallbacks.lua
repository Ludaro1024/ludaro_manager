--[[
    Example Callback Function

    This is a template for a server callback function. It explains how to use @param and @return for documentation
    and includes Debug statements to trace the execution flow.

    @param source (number): The server ID of the player who triggered the callback.
    @param someParameter (string): A parameter passed to the callback for processing.

    @return any: The return value of the callback, which could be any data type depending on the function's purpose.
]]
lib.callback.register("ludaro_manager:exampleCallback", function(source, someParameter)
   Debug(3, "Callback triggered by player with ID: " .. source)
   Debug(3, "Processing parameter: " .. someParameter)
   
   -- Example processing logic
   local result = "Processed result based on " .. someParameter

   Debug(3, "Callback processing complete. Returning result.")
   return result
end)
