-- On the other hand, it might be wise to try a different strategy: let the giant squid win.
-- 
-- You aren't sure how many bingo boards a giant squid could play at once, so rather than waste time counting its arms, the safe thing to do is to figure out which board will win last and choose that one. That way, no matter which boards it picks, it will win for sure.
-- 
-- In the above example, the second board is the last to win, which happens after 13 is eventually called and its middle column is completely marked. If you were to keep playing until this point, the second board would have a sum of unmarked numbers equal to 148 for a final score of 148 * 13 = 1924.
-- 
-- Figure out which board will win last. Once it wins, what would its final score be?
-- 
local file = io.open("input.txt", "r")

local input = {}

-- populate the grid(s) in the read loop
local grids = {}
local mt = {}
local row = {}

local i = 1
local j = 1

-- row returns a table provided a string, separator
local function splitRow(str, sep)
    local res = {}
    for s in string.gmatch(str, sep) do
        res[#res + 1] = tonumber(s)
    end
    return res
end

for line in file:lines() do
    -- first line is the input stream
    if i == 1 then
        input = splitRow(line, "%d+")
        goto continue
    end

    -- a blank line is an indicator that a new grid must be created
    -- and the current one must be lifted
    if line == "" then
        -- reset to new grid
        j = 1
        if #mt > 0 then
            table.insert(grids, mt)
            mt = {}
        end
        goto continue
    end

    -- get a row and add it to current grid
    row = splitRow(line, "%d+")
    mt[j] = row

    j = j + 1
    ::continue::
    i = i + 1
end

-- add the last grid, no newline at end of file
table.insert(grids, mt)

-- markGrid marks a grid (t) by replacing all values == mark with X
-- and then returns the new grid
local function markGrid(t, mark)
    for i = 1, #t do
        for y = 1, #t[i] do
            if t[i][y] == mark then
                t[i][y] = "X"
            end
        end
    end
    return t
end

-- gridSum calculates the sum of all unmarked grid items and returns it
local function gridSum(t)
    local sum = 0
    for i = 1, #t do
        for y = 1, #t[i] do
            if t[i][y] ~= "X" then
                sum = sum + t[i][y]
            end
        end
    end
    return sum
end

-- didGridWin checks if a grid (t) has at least one full column or row
local function didGridWin(t)
    for i = 1, #t do
        local w = true
        for j = 1, #t[i] do
            if t[i][j] ~= "X" then
                w = false
            end
        end

        if w then
            return true
        end

        local w = true
        for j = 1, #t[i] do
            if t[j][i] ~= "X" then
                w = false
            end
        end

        if w then
            return true
        end
    end

    return false
end

local function printGrid(t)
    for i = 1, #t do
        for j = 1, #t[i] do
            io.write(t[i][j], "\t")
        end
        io.write("\n")
    end
end

-- inputGrid inputs into the grid
-- evalGrid evalutes a table of grids for a winner
-- until they are exhausted
local function evalGrid(t, input, n)
    local d = {} -- new grids to keep. winners are discarded
    local mark = input[n]

    for i = 1, #t do
        t[i] = markGrid(t[i], mark)
        if not didGridWin(t[i]) then
            table.insert(d, t[i])
        end
    end

    -- there is one left, but it must play out until it wins.
    local nx = 0
    if #d == 1 then
        while true do
            if didGridWin(d[1]) then
                return d[1], input[n + nx]
            end
            nx = nx + 1
            d[1] = markGrid(d[1], input[n + nx])
        end
    end

    return evalGrid(d, input, n + 1)

end

grid, mark = evalGrid(grids, input, 1)
local sum = gridSum(grid)

assert(mark == 31)
assert(sum == 338)
assert(sum * mark == 10478)
