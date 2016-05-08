--[[
	Class for raising hills in the terrain
]]

Class = require "hump.class"

Hill = Class{}

function Hill:init(size)
	self.size = size
	self.x = math.random(1, self.size)
	self.y = math.random(1, self.size)
	self.radius = math.random(1, 4)
end

function Hill:height(x, y)
	local h = self.radius^2 - ( (self.x-x)^2 +  (self.y-y)^2 )
	if h < 0 then return 0 else return h end
end
