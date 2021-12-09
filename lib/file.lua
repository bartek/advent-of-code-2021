local file = {}

function file.read(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

function file.split(line, delim)
    local t = {}
    for c in string.gmatch(line, delim) do
        t[#t + 1] = c
    end
    return t
end

return file
