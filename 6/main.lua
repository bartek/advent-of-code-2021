local function read_file(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

local function table_from(line)
    local t = {}
    for c in string.gmatch(line, "%d+") do
        t[#t + 1] = c
    end
    return t
end

local t = table_from(read_file("input.txt"))

-- memoize this function. necessary to make part2 function well!
-- ref: https://www.lua.org/pil/17.1.html
local results = {}
setmetatable(results, {__mode = "v"}) -- make values weak, improving garbage collection cycle
local function tick(counter, days)
    local key = counter .. "-" .. days
    if results[key] then return results[key]
    else
        if days == 0 then
            local res = 1
            results[key] = res
            return res
        elseif counter == 0 then
            -- spawn a new fish
            local res = tick(8, days - 1) + tick(6, days - 1)
            results[key] = res
            return res
        else
            local res = tick(counter - 1, days - 1)
            results[key] = res
            return res
        end
    end
end

local function part1()
    local sum = 0

    for i = 1, #t do
        sum = sum + tick(t[i], 80)
    end
    assert(sum == 383160)
end

local function part2()
    local sum = 0
    for i = 1, #t do
        sum = sum + tick(t[i], 256)
    end
    assert(sum == 1721148811504)
end

part1()
part2()
