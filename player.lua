--[[
	Class for the user interactions
]]

Class = require "hump.class"

Player = Class{}

function Player:init(x, y)
	self.x, self.y = x, y
end

function Player:keypressed(key)
	if key == "w" then
		self.y = self.y - 1
	elseif key == "s" then
		self.y = self.y + 1
	elseif key == "a" then
		self.x = self.x - 1
	elseif key == "d" then
		self.x = self.x + 1
	end
end

function Player:draw()
	love.graphics.setColor(0xff, 0, 0)
	love.graphics.rectangle("fill", self.x*16, self.y*16, 1, 1)
end

function Player:chunk()
	local cx = math.floor(self.x/16)
	local cy = math.floor(self.y/16)
	return cx, cy
end
