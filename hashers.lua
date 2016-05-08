--[[
	Quick implementation of the BSD chksum algorithm
]]

local bit = require "bit"

function bsdsum(s)
	local chksum = 0
	for c in s:gmatch(".") do
		chksum = bit.rshift(chksum, 1) + bit.lshift(bit.band(chksum, 1), 15)
		chksum = chksum + string.byte(c)
		chksum = bit.band(chksum, 0xFFFF)
	end
	return chksum
end

function fletcher16(s)
	local sum1, sum2 = 0, 0
	for c in s:gmatch(".") do
		sum1 = (sum1 + string.byte(c)) % 255
		sum2 = (sum2 + sum1) % 255
	end
	return bit.bor(bit.lshift(sum2, 8), sum1)
end
