package.path = package.path .. ";../?.lua"

local file = require("lib.file")
local collections = require("lib.collections")

local pairs = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
    ["<"] = ">",
}

function score(corrupt)
    local scores = {
        [")"] = 3,
        ["]"] = 57,
        ["}"] = 1197,
        [">"] = 25137,
    }
    local sum = 0
    for i = 1, #corrupt do
        sum = sum + scores[corrupt[i]]
    end
    return sum
end

function score_autocomplete(incomplete)
    local scores = {
        ["("] = 1,
        ["["] = 2,
        ["{"] = 3,
        ["<"] = 4,
    }

    local sum = 0
    for i = #incomplete, 1, -1 do
        local c = incomplete[i]
        sum = (sum * 5) + scores[c]
    end
    return sum
end

-- parse returns the stack, identifying if incomplete or not
function parse(line)
    local corrupt = {}
    local stack = {}

    for c in string.gmatch(line, "%g") do
        -- add to stack if opening char
        if pairs[c] ~= nil then
            stack[#stack + 1] = c
        else
            -- if closer, check if matches last opener
            if c == pairs[stack[#stack]] then
                table.remove(stack, #stack)
            -- does not match last on stack, is corrupted
            else
                table.insert(corrupt, c)
                break
            end
        end
    end

    -- was incomplete, not corrupt
    if #corrupt == 0 then
        return stack, true
    end
    return corrupt, false
end

function part1()
    local t = file.lines("input.txt")

    local sum = 0
    for i = 1, #t do
        local parsed, is_incomplete = parse(t[i])
        if not is_incomplete then
            sum = sum + score(parsed)
        end
    end

    assert(sum == 193275)
end

function part2()
    local t = file.lines("input.txt")

    local scores = {}
    for i = 1, #t do
        local parsed, is_incomplete = parse(t[i])
        if is_incomplete then
            scores[#scores + 1] = score_autocomplete(parsed)
        end
    end

    -- get median
    local m = collections.median(scores)
    assert(m == 2429644557)
end

part1()
part2()
