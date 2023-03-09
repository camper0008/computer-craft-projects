local util = {};

util.char_color_map = {
    ["."] = colors.lightGray,
    w = colors.white,
    r = colors.red,
    o = colors.orange,
    y = colors.yellow,
    g = colors.green,
    b = colors.blue,
}

util.grids = function(password)
    local input_grid = {};
    local password_grid = {};
    local y = 1;
    for line in password:gmatch("%S+") do
        local x = 1;
        password_grid[y] = {};
        input_grid[y] = {};
        for char in line:gmatch("%S") do
            password_grid[y][x] = util.char_color_map[char];
            input_grid[y][x] = colors.lightGray;
            x = x + 1;
        end
        y = y + 1;
    end
    return password_grid, input_grid;
end

util.grids_equal = function(password, input)
    for y = 1, 10 do
        for x = 1, 10 do
            if password[y][x] ~= input[y][x] then
                return false
            end
        end
    end
    return true
end

return util;
