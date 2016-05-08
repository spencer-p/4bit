--[[
	Point of Interest class
]]

Class = require "hump.class"

Landmark = Class{}

function Landmark:init(size)
	self.size = size
	self.x = math.random(1, self.size)
	self.y = math.random(1, self.size)
end
