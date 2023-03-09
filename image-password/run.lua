local password = require("password");
local util = require("util");
local size_x, size_y = term.getSize();
paintutils.drawFilledBox(1, 1, size_x, size_y, colors.black);
local center_x = math.floor(size_x / 2);
local center_y = math.floor(size_y / 2);

local enter_text = "[accept]"

local password_grid, input_grid = util.grids(password);

local color_picker = {
    colors.lightGray,
    colors.white,
    colors.red,
    colors.orange,
    colors.yellow,
    colors.green,
    colors.blue,
};
local current_color = colors.white;
paintutils.drawFilledBox(center_x - 4, center_y - 4, center_x + 5, center_y + 5, colors.lightGray);
for y, color in ipairs(color_picker) do
    paintutils.drawFilledBox(1, y * 2 + 2, 2, y * 2 + 2, color)
end
local function draw_enter_button()
    local pos = (size_x - enter_text:len()) / 2 + 1
    term.setCursorPos(pos, 16)
    term.setTextColor(colors.white);
    term.setBackgroundColor(colors.black);
    term.write(enter_text)
end
local function handle_mouse_press(button, x, y)
    if x <= 2 then
        local hovered_color = math.floor((y - 2) / 2);
        if color_picker[hovered_color] then
            current_color = color_picker[hovered_color]
            return
        end
    end
    local normalized_x = x - center_x - 5 + 10;
    local normalized_y = y - center_y - 5 + 10;
    if normalized_x >= 1 and normalized_x <= 10
        and normalized_y >= 1 and normalized_y <= 10 then
        paintutils.drawPixel(x, y, current_color);
        input_grid[normalized_y][normalized_x] = current_color;
        return
    end

    local pos = (size_x - enter_text:len()) / 2;
    if y == 16 and x >= pos and x <= pos + enter_text:len() then
        if util.grids_equal(password_grid, input_grid) then
            term.setCursorPos(1, 1);
            term.setBackgroundColor(colors.black)
            term.clear();
            error();
        else
            term.setCursorPos(22, 3);
            term.setBackgroundColor(colors.red);
            term.write("invalid!");
        end
    end
end
draw_enter_button();
while true do
    local event, button, x, y = os.pullEvent("mouse_click");
    handle_mouse_press(button, x, y)
end
