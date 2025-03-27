local socket = require("socket")
local server = assert(socket.bind("0.0.0.0", 8080)) -- Open on port 8080
server:settimeout(0) -- Non-blocking

print("Executor API running on ws://localhost:8080")

while true do
    local client = server:accept()
    if client then
        client:settimeout(10)
        local script, err = client:receive()

        if script then
            print("Received script: " .. script)
            local success, result = pcall(loadstring(script))

            if success then
                client:send("Execution Successful: " .. tostring(result) .. "\n")
            else
                client:send("Error: " .. tostring(result) .. "\n")
            end
        end

        client:close()
    end
end

