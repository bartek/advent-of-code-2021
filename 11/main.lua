package.path = package.path .. ";../?.lua"

local file = require("lib.file")
local grid = require("lib.grid")

-- For readability sake, model the directions as a table
local directions = {
    {x = 1, y = -1}, -- north east
    {x = -1, y = -1}, -- north west

    {x = 0, y = -1}, -- north
    {x = 1, y = 0}, -- east
    {x = -1, y = 0}, -- west
    {x = 0, y = 1}, -- south

    {x = 1, y = 1}, -- south east
    {x = -1, y = 1}, -- south west
}

-- get neighbours for a grid t where focus is on {x, y}
-- a table of directions must be supplied
local function get_neighbours(t, y, x)
    local neighbours = {}
    for _, dir in pairs(directions) do
        local xx = x + dir.x
        local yy = y + dir.y
        if t[yy] and t[yy][xx] then
            neighbours[#neighbours + 1] = {y = yy, x = xx}
        end
    end

    return neighbours
end

--  flash flashes an octopus by identifying its neighbours and providing them
--  some light (which results in a +1 to their cell value!) this recursively
--  expands as long as there are flashes to do but it can only occur once per
--  octopus
local function flash(t, bursts)
    local add = {}
    for i = 1, #bursts do
        local y = bursts[i].y
        local x = bursts[i].x
        for _, n in pairs(get_neighbours(t, y, x)) do
            if t[n.y][n.x] == 9 then
                add[#add + 1] = {y = n.y, x = n.x}
            end
            t[n.y][n.x] = t[n.y][n.x] + 1
        end
    end
    if #add > 0 then
        flash(t, add)
    end
end

local function step(t)
    local bursts = {}
    for y = 1, #t do
        for x = 1, #t[y] do
            t[y][x] = t[y][x] + 1
            if t[y][x] > 9 then
                bursts[#bursts + 1] = {x = x, y = y}
            end
        end
    end

    -- recurively flash (only once) all octopi which reached the threshold
    flash(t, bursts)

    -- count flashes and reset
    local counter = 0
    for y = 1, #t do
        for x = 1, #t[y] do
            if t[y][x] > 9 then
                t[y][x] = 0
                counter = counter + 1
            end
        end
    end
    return counter
end

-- how many flashes after 100 steps?
local function part1()
    local t = grid.make_numbered(file.lines("input.txt"))

    local sum = 0
    for i = 1, 100 do
        sum = sum + step(t)
    end
    assert(sum == 1649)
end

-- when is the grid flashed all at once?
local function part2()
    local t = grid.make_numbered(file.lines("input.txt"))

    -- all octopi have flashed if counter == rows * cols
    local rows, cols = #t, #t[1]
    local max = rows * cols

    local i = 1
    while true do
        local c = step(t)
        if c >= max then
            break
        end
        i = i + 1
    end
    assert(i == 256)
end

part1()
part2()
