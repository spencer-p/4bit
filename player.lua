--[[
	Class for the user interactions
]]

Class = require "hump.class"
vector = require "hump.vector"

Player = Class{}

-- TODO implement a movement stack

function Player:init(x, y)
	self.pos = vector(x, y)
	self.velStack = {}
	self.speed = 1
	self.sprites = love.graphics.newImage("assets/player.png")
	self.sprites:setFilter("nearest", "nearest")
	self.frames = {
		size = 16,
		front = love.graphics.newQuad(0, 0, 16, 16, 16*6, 16),
		back = love.graphics.newQuad(16, 0, 16, 16, 16*6, 16),
		left = love.graphics.newQuad(32, 0, 16, 16, 16*6, 16),
		frontstep = love.graphics.newQuad(48, 0, 16, 16, 16*6, 16),
		backstep = love.graphics.newQuad(64, 0, 16, 16, 16*6, 16),
		leftstep = love.graphics.newQuad(80, 0, 16, 16, 16*6, 16)
	}
	self.flip = true --i'm a sucker for the left foot step out
	self.facing = "s" --face user at start
	self:velPush(vector(0, 0)) --leaves nil in key
end

function Player:keypressed(key)
	-- Movement block
	if string.find("wasd", key) then
		local vel = vector(0, 0)
		if key == "w" then
			vel.y = vel.y - self.speed
		elseif key == "s" then
			vel.y = vel.y + self.speed
		elseif key == "a" then
			vel.x = vel.x - self.speed
		elseif key == "d" then
			vel.x = vel.x + self.speed
		end
		self:velPush(vel, key)
		self.facing = key
	end
end

function Player:keyreleased(key)
	-- Movement block
	if string.find("wasd", key) then
		self:velPop(key)
		if #self.velStack ~= 1 then
			self.facing = self:velGet()[2]
		end
	end
end

function Player:velPush(vel, key)
	table.insert(self.velStack, { vel, key })
end

function Player:velPop(key) --we want to remove vectors that arent most recent
	for i, n in ipairs(self.velStack) do
		if n[2] == key then
			table.remove(self.velStack, i)
			return
		end
	end
end

-- Returns array with vel and key
function Player:velGet()
	return self.velStack[#self.velStack]
end

function Player:draw()
	local sx = 1 -- x scale (only -1 or 1 for flipping anim)
	local sprite = self.frames.front
	local vel = unpack(self:velGet())
	if self.facing == "w" then --up
		if self.flip then 
			sx = -1
		end
		if vel == vector(0, 0) then --not moving
			sx = 1 -- no flipping if not moving
			sprite = self.frames.back
		else --moving
			sprite = self.frames.backstep
		end
	elseif self.facing == "s" then --down
		if self.flip then
			sx = -1
		end
		if vel == vector(0, 0) then --not moving
			sx = 1 -- no flipping if not moving
			sprite = self.frames.front
		else --moving
			sprite = self.frames.frontstep
		end
	elseif self.facing == "a" then --left
		if vel == vector(0, 0) or not self.flip then --either not moving or midstep (same frame)
			sprite = self.frames.left
		else
			sprite = self.frames.leftstep
		end
	elseif self.facing == "d" then --right
		sx = -1
		if vel == vector(0, 0) or not self.flip then --same as above
			sprite = self.frames.left
		else
			sprite = self.frames.leftstep
		end
	end
	local x = self.pos.x - 0.5 * self.frames.size * sx
	local y = self.pos.y - 0.5 * self.frames.size

	love.graphics.draw(self.sprites, sprite, x, y, 0, sx, 1)
	love.graphics.setColor(0xff, 0, 0)
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, 1, 1)
end

function Player:chunk()
	local cx = math.floor(self.pos.x/16^2)
	local cy = math.floor(self.pos.y/16^2)
	return cx, cy
end

function Player:update(dt)

	local vel = unpack(self:velGet())
	self.pos = self.pos + vel -- 60 pixels every second

	if vel ~= vector(0, 0) then
		if not self.counter then
			self.counter = 0
		end
		self.counter = self.counter + dt

		if self.counter >= 1/4 then
			if self.flip then self.flip = false else self.flip = true end
			self.counter = 0
		end
	elseif self.counter ~= 0 then
		self.counter = 0
		self.flip = true
	end

end
