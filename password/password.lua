local password = "123456789"

local password_input = "";

local width, height = term.getSize()

local keymap = require("keymap");

while true do
    term.clear()

    term.setCursorPos(width / 2 - 6, height / 2 - 1)
    term.write("Type password")

    term.setCursorPos(width / 2 - math.floor(#password/2 + 0.5), height / 2)
    term.write("[" .. 
        ("*"):rep(#password_input) .. 
        ("_"):rep(#password - #password_input) .. 
    "]")

    term.setCursorPos(width / 2 - 3, height / 2)
    local _, key = os.pullEvent("key")

    term.setCursorPos(1,1)

    if key == keys.enter then
        if password == password_input then
            redstone.setOutput("left", true)
            sleep(2)
            redstone.setOutput("left", false)
            term.clear()
            term.setCursorPos(1, 1)
        else
            term.setCursorPos(width / 2 - 8, height / 2)
            term.write("incorrect password")
            sleep(2)
        end
        password_input = "";
    elseif key == keys.backspace then
        password_input = password_input:sub(1, #password_input-1)
    elseif #password_input < #password and keymap[key] then
        password_input = password_input .. keymap[key] 
    end
end
