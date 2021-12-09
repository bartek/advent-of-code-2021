package.path = package.path .. ";../?.lua"

local file = require("lib.file")

local c = file.read("sample.txt")

local function median(t)
    table.sort(t, function(a, b) return (a > b) end)
    return t[#t / 2]
end

local function average(t)
    local sum = 0
    for i = 1, #t do
        sum = sum + t[i]
    end
    return math.floor(sum / #t)
end

-- Instead, each change of 1 step in horizontal position costs 1 more unit of fuel than the last: the first step costs 1, the second step costs 2, the third step costs 3, and so on.
local function distance_cost(n)
    local c = 0
    for i = n, 0, -1 do
        c = c + i
    end
    return c
end

-- distanceCost is a boolean to identify if the cost of distance should be added to the fuel cost
local function fuel_cost(t, dest, distanceCost)
    local fuel = 0
    for i = 1, #t do
        if distanceCost then
            local d = math.abs(dest - t[i])
            fuel = fuel + distance_cost(d)
        else
            fuel = fuel + math.abs(dest - t[i])
        end
    end
    return math.floor(fuel)
end

local function part1()
    local input = file.read("input.txt")
    local t = {}
    for c in string.gmatch(input, "%d+") do
        t[#t + 1] = tonumber(c)
    end

    local dest = median(t)
    local cost = fuel_cost(t, dest, false)

    assert(cost == 356179)
end

local function part2()
    local input = file.read("input.txt")
    local t = {}
    for c in string.gmatch(input, "%d+") do
        t[#t + 1] = tonumber(c)
    end

    local dest = average(t)
    local cost = fuel_cost(t, dest, true)

    assert(cost == 99788435)
end


part1()
part2()
