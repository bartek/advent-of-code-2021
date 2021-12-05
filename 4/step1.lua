-- --- Day 4: Giant Squid ---
--You're already almost 1.5km (almost a mile) below the surface of the ocean, already so deep that you can't see any sunlight. What you can see, however, is a giant squid that has attached itself to the outside of your submarine.
--
--Maybe it wants to play bingo?
--
--Bingo is played on a set of boards each consisting of a 5x5 grid of numbers. Numbers are chosen at random, and the chosen number is marked on all boards on which it appears. (Numbers may not appear on all boards.) If all numbers in any row or any column of a board are marked, that board wins. (Diagonals don't count.)
--
--The submarine has a bingo subsystem to help passengers (currently, you and the giant squid) pass the time. It automatically generates a random order in which to draw numbers and a random set of boards (your puzzle input). For example:
--
--7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
--
--22 13 17 11  0
-- 8  2 23  4 24
--21  9 14 16  7
-- 6 10  3 18  5
-- 1 12 20 15 19
--
-- 3 15  0  2 22
-- 9 18 13 17  5
--19  8  7 25 23
--20 11 10 24  4
--14 21 16 12  6
--
--14 21 17 24  4
--10 16 15  9 19
--18  8 23 26 20
--22 11 13  6  5
-- 2  0 12  3  7
--After the first five numbers are drawn (7, 4, 9, 5, and 11), there are no winners, but the boards are marked as follows (shown here adjacent to each other to save space):
--
--22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
-- 8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
--21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
-- 6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
-- 1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
--After the next six numbers are drawn (17, 23, 2, 0, 14, and 21), there are still no winners:
--
--22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
-- 8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
--21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
-- 6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
-- 1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
--Finally, 24 is drawn:
--
--22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
-- 8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
--21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
-- 6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
-- 1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
--At this point, the third board wins because it has at least one complete row or column of marked numbers (in this case, the entire top row is marked: 14 21 17 24 4).
--
--The score of the winning board can now be calculated. Start by finding the sum of all unmarked numbers on that board; in this case, the sum is 188. Then, multiply that sum by the number that was just called when the board won, 24, to get the final score, 188 * 24 = 4512.
--


-- create a 5x5 grid for the board
-- be able to identify at least one complete column or row
-- calculate score: sum of all unmarked numbers, mulitplied by number that was just called
--  ... cant erase the grid, need to know the input stream
--  figure out which board wins first


-- row returns a table provided a string, separator
local function splitRow(str, sep)
    local res = {}
    for s in string.gmatch(str, sep) do
        res[#res + 1] = s
    end
    return res
end

local file = io.open("input.txt", "r")

local input = {}

-- populate the grid(s) in the read loop
local grids = {}
local mt = {}
local row = {}

local i = 1
local j = 1
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

        -- row success!
        if w then
            return true
        end

        for j = 1, #t[i] do
            if t[j][i] ~= "X" then
                w = false
            end
        end

        -- column success!
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


local i = 1
local done = false
local result = 0
while true do
    if done == true then
        break
    end
    -- read input, one by one
    mark = input[i]
    if mark == nil then
        break
    end

    -- search for mark in grids and mark as X
    -- this is probably a bad idea that will bite me in step2
    for i = 1, #grids do
        grids[i] = markGrid(grids[i], mark)

        -- check if winner
        if didGridWin(grids[i]) then
            print("Winner is", i)
            local sum = gridSum(grids[i])
            result = sum * mark
            done = true
            break
            -- get score
        end

        printGrid(grids[i])
        print("\n")

    end
    i = i + 1
end


assert(result == 41668)
