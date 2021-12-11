local collections = {}

function collections.median(t)
    table.sort(t, function(a, b) return a < b end)

    if math.fmod(#t, 2) == 0 then
        return (t[#t / 2] + t[(#t / 2) + 1]) / 2
    else
        return t[math.ceil(#t / 2)]
    end
end

return collections
