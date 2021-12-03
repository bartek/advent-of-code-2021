-- --- Day 3: Binary Diagnostic ---
-- The submarine has been making some odd creaking noises, so you ask it to produce a diagnostic report just in case.
-- 
-- The diagnostic report (your puzzle input) consists of a list of binary numbers which, when decoded properly, can tell you many useful things about the conditions of the submarine. The first parameter to check is the power consumption.
-- 
-- You need to use the binary numbers in the diagnostic report to generate two new binary numbers (called the gamma rate and the epsilon rate). The power consumption can then be found by multiplying the gamma rate by the epsilon rate.
-- 
-- Each bit in the gamma rate can be determined by finding the most common bit in the corresponding position of all numbers in the diagnostic report. For example, given the following diagnostic report:
-- 
-- 00100
-- 11110
-- 10110
-- 10111
-- 10101
-- 01111
-- 00111
-- 11100
-- 10000
-- 11001
-- 00010
-- 01010
-- Considering only the first bit of each number, there are five 0 bits and seven 1 bits. Since the most common bit is 1, the first bit of the gamma rate is 1.
-- 
-- The most common second bit of the numbers in the diagnostic report is 0, so the second bit of the gamma rate is 0.
-- 
-- The most common value of the third, fourth, and fifth bits are 1, 1, and 0, respectively, and so the final three bits of the gamma rate are 110.
-- 
-- So, the gamma rate is the binary number 10110, or 22 in decimal.
-- 
-- The epsilon rate is calculated in a similar way; rather than use the most common bit, the least common bit from each position is used. So, the epsilon rate is 01001, or 9 in decimal. Multiplying the gamma rate (22) by the epsilon rate (9) produces the power consumption, 198.
-- 
-- Use the binary numbers in your diagnostic report to calculate the gamma rate and epsilon rate, then multiply them together. What is the power consumption of the submarine? (Be sure to represent your answer in decimal, not binary.)

local file = io.open("input.txt", "r")

local t = {}
local function splitToArray(str)
    if #str == 0 then
        return nil
    end

    local arr = {}
    for i = 1, #str do
        local c = string.sub(str, i, i)
        table.insert(arr, tonumber(c))
    end

    return arr
end

-- "flip" the input into t. if input looks like
-- 00100
-- 11110
-- 10110
-- then t would look like:
-- {
--  [1] = {0, 1, 1}
--  [2] = {0, 1, 1}
--  [3] = {1, 1, 1}
--  [4] = {0, 1, 1}
--  [5] = {0, 0, 0}
-- }
--

for line in file:lines() do
    local b = splitToArray(line)

    -- collect bits into table
    for j = 1, #b do
        tx = tostring(j)
        if t[tx] == nil then
            t[tx] = {}
        end

        idx = t[tx]
        table.insert(idx, b[j])
    end
end

-- now that we have the map, sum up each entry
-- and execute the logic as per the problem
local gamma = ""
local epsilon = ""
for i = 1, 12 do
    idx = tostring(i)

    local sum = 0
    for j = 1, #t[idx] do
        sum = sum + t[idx][j]
    end

    if sum > #t[idx] / 2 then
        gamma = gamma .. "0"
        epsilon = epsilon .. "1"
    else
        gamma = gamma .. "1"
        epsilon = epsilon .. "0"
    end
end

v1 = tonumber(gamma, 2)
v2 = tonumber(epsilon, 2)
assert(v1 * v2 == 4174964)
