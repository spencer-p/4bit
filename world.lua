--[[
	The whole world!
]]

Class = require "hump.class"

require "chunk"
require "hashers"

World = Class{}

function World:init(seed)
	self.seed = seed
	self.chunks = {}
	self.waterheight = 0.1
	self.landheight = 0.35
	self.textures = {}
	self.textures.water = {}
	self.textures.water.tiles = love.graphics.newImage("assets/water.png")
	self.textures.water.tiles:setFilter("nearest", "nearest")
	self.textures.water.size = 16
	self.textures.water.quads = {}
	for i = 1, 16 do
		self.textures.water.quads[i] = love.graphics.newQuad((i-1)*self.textures.water.size, 0, self.textures.water.size, self.textures.water.size, 16*self.textures.water.size, self.textures.water.size)
	end
end

function World:get(x, y)
	self:assertexists(x, y)
	return self.chunks[x][y]
end

function World:assertexists(x, y)
	if not self.chunks[x] then
		self.chunks[x] = {}
	end
	if not self.chunks[x][y] then
		self.chunks[x][y] = self:generate(x, y)
	end
end

function World:exists(x, y)
	return self.chunks[x] and self.chunks[x][y]
end

function World:generate(x, y)
	--TODO: srand with a hash of seed, x, y
	math.randomseed(fletcher16(self.seed..tostring(x)..tostring(y)))
	return Chunk(self, x, y)
end

function World:draw(centerx, centery)
	for i = centerx-3, centerx+3 do
		for j = centery-3, centery+3 do
			self:assertexists(i, j)
			self.chunks[i][j]:draw()
		end
	end
end

function World:update(centerx, centery)
	-- First update detail
	for i = centerx-3, centerx+3 do
		for j = centery-3, centery+3 do
			self:assertexists(i, j)
			self.chunks[i][j]:detail()
		end
	end
end

