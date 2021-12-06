local function lines_from(f)
    local lines = {}
    for line in io.lines(f) do
        lines[#lines + 1] = line
    end
    return lines
end

-- expand the inputs. for each one, identify if the line is horizontal or vertical
-- and identify the missing points, add them to a table
local function coords_from(lines)
    local maxX = 0
    local maxY = 0
    local t = {}

    for i = 1, #lines do
        local coords = {}
        for c in string.gmatch(lines[i], "%d+") do
            -- add +1 since lua starts 1-index. makes life easier
            coords[#coords + 1] = tonumber(c + 1)
        end

        maxX = math.max(maxX, coords[1], coords[3])
        maxY = math.max(maxY, coords[2], coords[4])
        table.insert(t, coords)
    end
    return t, maxX, maxY
end

-- part1: only get horizontal/vertical
local function filter_coords(coords)
    local t = {}
    for i = 1, #coords do
        local c = coords[i]
        if c[1] == c[3] or c[2] == c[4] then
            table.insert(t, c)
        end
    end
    return t
end

-- make_grid creates a grid of size x,y
local function make_grid(x, y)
    local t = {}
    for i = 1, y do
        local row = {}
        for j = 1, x do
            row[j] = 0
        end
        t[i] = row
    end
    return t
end

-- print_grid is a helper during sample
local function print_grid(t)
    for i = 1, #t do
        for j = 1, #t[i] do
            if t[i][j] == 0 then
                io.write(".")
            else
                io.write(t[i][j])
            end
        end
        io.write("\n")
    end
end


-- line_from_points collects all the points that make a line (horizontal, vertical, or diagonal)
-- between the provided points
-- returns a table in the form: t = {{x1, y1}, {x2, y2}, {x3, y3}, ...}
local function line_from_points(x1, y1, x2, y2)

    -- swap starting points so we're always going from left to right 
    if x1 > x2 then
        x1, x2, y1, y2 = x2, x1, y2, y1
    end

    -- get distance
    local dist = math.ceil( 
        math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2))
    )

    local difference = {x1 - x2, y1 - y2}
    local direction = {difference[1] / dist, difference[2] / dist}

    -- add the starting point
    local t = {{x1, y1}}

    -- x is going right (always due to swap)
    if direction[1] == -1 then
        for i = 1, dist - 1 do
            table.insert(t, {x1 + i, y1})
        end
    -- y1 is going up towards y2
    elseif direction[2] == -1 then
        for i = 1, dist - 1 do
            table.insert(t, {x1, y1 + i})
        end
    -- y1 is going down towards y2
    elseif direction[2] == 1 then
        for i = 1, dist - 1 do
            table.insert(t, {x1, y1 - i})
        end
    -- y1 is going down towards y2, x to the right
    elseif direction[1] < 0 and direction[2] > 0 then
        for i = 1, dist -1 do
            if x1 + i == x2 and y1 - i == y2 then
                break
            end
            table.insert(t, {x1 + i, y1 - i})
        end
    -- y1 is going up towards y2, x to the right
    elseif direction[1] < 0 and direction[2] < 0 then
        for i = 1, dist - 1 do
            if x1 + i == x2 and y1 + i == y2 then
                break
            end
            table.insert(t, {x1 + i, y1 + i})
        end
    end

    -- add the ending point
    -- probably better off sorting the table
    table.insert(t, {x2, y2})

    return t
end

-- mark_grid marks a grid with a visit by incrementing that current position by 1
-- and returns the grid
local function mark_grid(t, x, y)
    t[y][x] = t[y][x] + 1
    return t
end

local function part1(filename)
    local lines = lines_from(filename)
    local coords, maxX, maxY = coords_from(lines)
    coords = filter_coords(coords)

    local grid = make_grid(maxX, maxY)

    for i = 1, #coords do
        local d = coords[i]

        local l = line_from_points(d[1], d[2], d[3], d[4])
        for i = 1, #l do
            grid = mark_grid(grid, l[i][1], l[i][2])
        end
    end

    local sum = 0
    for i = 1, #grid do
        for j = 1, #grid[i] do
            if grid[i][j] > 1 then
                sum = sum + 1
            end
        end
    end

    assert(sum == 6461)
end

local function part2(filename)
    local lines = lines_from(filename)
    local coords, maxX, maxY = coords_from(lines)
    local grid = make_grid(maxX, maxY)

    for i = 1, #coords do
        local d = coords[i]

        local l = line_from_points(d[1], d[2], d[3], d[4])
        for i = 1, #l do
            grid = mark_grid(grid, l[i][1], l[i][2])
        end
    end

    local sum = 0
    for i = 1, #grid do
        for j = 1, #grid[i] do
            if grid[i][j] > 1 then
                sum = sum + 1
            end
        end
    end

    assert(sum == 18065)
end

part1("input.txt")
part2("input.txt")

-- ### Tests

-- assertWalk is a helper since comparing tables isn't builtin to Lua
local function assertWalk(t, ...)
    for i, v in ipairs{...} do
        assert(t[i][1] == v[1])
        assert(t[i][2] == v[2])
    end
end

-- test line_from_points since it's the critical path of this test
assertWalk(
    line_from_points(1, 1, 1, 3),
    {1, 1}, {1, 2}, {1, 3}
)

assertWalk(
    line_from_points(9, 7, 7, 7),
    {7, 7}, {8, 7}, {9, 7}
)

assertWalk(
    line_from_points(1, 10, 6, 10),
    {1, 10}, {2, 10}, {3, 10}, {4, 10}, {5, 10}, {6, 10}
)

assertWalk(
    line_from_points(3, 3, 3, 2),
    {3, 3}, {3, 2}
)

assertWalk(
    line_from_points(1, 1, 3, 3),
    {1, 1}, {2, 2}, {3, 3}
)

assertWalk(
    line_from_points(9, 7, 7, 9),
    {7, 9}, {8, 8}, {9, 7}
)
