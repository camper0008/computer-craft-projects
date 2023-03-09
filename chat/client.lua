io.write("server id: ")
local server_id = tonumber(io.read())
rednet.send(server_id, "/my_username")
local _, my_username = rednet.receive()

if my_username ~= nil then
    print("logged in as " .. my_username)
else
    print("no username on record. set username with /username")
end

local has_printed_chat = false;

local function server_output()
    local id, server_message = rednet.receive(5);
    if id ~= server_id then return end
    print(server_message)
    has_printed_chat = false;
end

local function user_input()
    if not has_printed_chat then
        io.write("chat: ");
        has_printed_chat = true;
    end
    local message = io.read();
    rednet.send(server_id, message);
    has_printed_chat = false;
end

while true do
    parallel.waitForAny(user_input, server_output)
end
