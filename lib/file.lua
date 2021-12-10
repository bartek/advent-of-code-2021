local file = {}

function file.read(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

-- return each line in a file as an entry in a table
function file.lines(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local t = {}
    for line in file:lines() do
        t[#t + 1] = line
    end
    file:close()
    return t
end

function file.split(line, delim)
    local t = {}
    for c in string.gmatch(line, delim) do
        t[#t + 1] = c
    end
    return t
end


return file
