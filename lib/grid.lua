local grid = {}

-- turn a blob of input data that looks like a grid into a grid structure (as a table, of course)
--
-- e.g. the input should look like
-- 2199943210
-- 3987894921
-- 9856789892
-- 8767896789
-- 9899965678
function grid.make_numbered(t)
    local grid = {}
    for i = 1, #t do
        -- each t[i] is a row
        grid[i] = {}
        local j = 1
        for c in string.gmatch(t[i], "%d") do
            grid[i][j] = tonumber(c)
            j = j + 1
        end
    end
    return grid
end

function grid.print(t)
    for i = 1, #t do
        for j = 1, #t[i] do
            io.write(t[i][j])
        end
        print("")
    end
end

return grid
