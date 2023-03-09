local storage = { users = {} };

storage.find_user = function(self, username)
    for id, other_username in pairs(self.users) do
        if other_username == username then
            return id
        end
    end
    return nil
end

local function handle_command(id, message)
    local command = message:match("^/(%S+)");
    if command == nil then
        return "server: invalid command";
    end
    if command:lower() == "my_username" then
        return storage.users[id];
    end
    if command:lower() == "username" then
        if storage.users[id] ~= nil then
            return "server: you already have a username"
        end
        local username = message:match("^/%S+ (%S+)");
        local taken_id = storage:find_user(username);
        if taken_id ~= nil or username == "server" then
            return "server: that username is taken";
        end
        storage.users[id] = username;
        return "server: username set";
    end

    return "server: unknown command: '" .. command .. "'";
end

local function handle_server_input(id, message)
    if message:sub(1, 1) == "/" then
        local command_message = handle_command(id, message)
        rednet.send(id, command_message)
        return
    end
    if storage.users[id] == nil then
        rednet.send(id, "server: you do not have a username. set a username with /username <username>")
        return;
    end
    local message_with_user = storage.users[id] .. ": " .. message;
    for other_id, _ in pairs(storage.users) do
        if other_id ~= id then
            rednet.send(other_id, message_with_user);
        end
    end
end

print("Listening on server id: " .. os.getComputerID())

while true do
    local id, message = rednet.receive();
    print("got message from " .. id .. ": " .. message);
    handle_server_input(id, message);
end
