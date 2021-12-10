package.path = package.path .. ";../?.lua"

local file = require("lib.file")
local grid = require("lib.grid")

-- get_neighbours gets all valid coordinates adjacent to point {i, j}
local function get_neighbours(point, t)
    local i, j = point[1], point[2]
    local n = {}
    if t[i][j - 1] ~= nil then
        n[#n + 1] = {i, j - 1}
    end
    if t[i][j + 1] ~= nil then
        n[#n + 1] = {i, j + 1}
    end
    if t[i - 1] and t[i - 1][j] ~= nil then
        n[#n + 1] = {i - 1, j}
    end
    if t[i + 1] and t[i + 1][j] ~= nil then
        n[#n + 1] = {i + 1, j}
    end
    return n
end

-- get_values accepts a table of points (n) and gets their values from table (t)
-- points are as returned by get_neighbours ({ {i1, j1}, {i2, j2}, ...})
local function get_values(n, t)
    local r = {}
    for i = 1, #n do
        local i, j = n[i][1], n[i][2]
        table.insert(r, t[i][j])
    end
    return r
end


local function basin_size(point, t, visited)
    local size = 1

    for _, v in pairs(get_neighbours(point, t)) do
        local i, j = v[1], v[2]
        if visited[i .. "-" .. j] then
            goto continue
        end

        visited[i .. "-" .. j] = true

        -- continue recursion until 9 is the neighbour (the "wall" of the basin)
        if t[i][j] ~= 9 then
            size = size + basin_size(v, t, visited)
        end
        ::continue::
    end
    return size
end


local function part1()
    local t = grid.make_numbered(file.lines("input.txt"))

    local lowPoints = {}

    local rows, columns = #t, #t[1]
    for i = 1, rows do
        for j = 1, columns do
            local n = get_neighbours({i, j}, t)
            local v = get_values(n, t)
            if math.min(table.unpack(v)) > t[i][j] then
                table.insert(lowPoints, t[i][j])
            end
        end
    end

    local sum = 0
    for i = 1, #lowPoints do
        sum = sum + lowPoints[i] + 1
    end
    
    assert(sum == 594)
end

local function part2()
    local t = grid.make_numbered(file.lines("input.txt"))

    -- lows contains the coordinates for lowest point e.g {i, j}
    local lows = {}
    local rows, columns = #t, #t[1]

    for i = 1, rows do
        for j = 1, columns do
            local n = get_neighbours({i, j}, t)
            local v = get_values(n, t)

            if math.min(table.unpack(v)) > t[i][j] then
                table.insert(lows, {i, j})
            end
        end
    end

    local basins = {}
    local visited = {} -- a map of visited points
    for i = 1, #lows do
        visited[lows[i][1] .. "-" .. lows[i][2]] = true
        basins[#basins + 1] = basin_size(lows[i], t, visited)
    end

    -- Now having all the basins, sort them to find the three largest
    table.sort(basins, function(a, b) return (a > b) end)

    local sum = basins[1] * basins[2] * basins[3]
    assert(sum == 858494)
end

part1()
part2()
