--[[
	The whole world!
]]

Class = require "hump.class"

require "chunk"
require "hashers"

World = Class{}

local bitmasks = { 0, 2, 8, 10, 11, 16, 18, 22, 24, 26, 27, 30, 31, 64, 66, 72, 74, 75, 80, 82, 86, 88, 90, 91, 94, 95, 104, 106, 107, 120, 122, 123, 126, 127, 208, 210, 214, 216, 218, 219, 222, 223, 248, 250, 251, 254, 255, 0 }

function World:init(seed)
	self.seed = seed
	self.chunks = {}
	self.waterheight = 0.1
	self.landheight = 0.35
	self.textures = {}
	self.textures.tiles = love.graphics.newImage("assets/tiles.png")
	self.textures.tiles:setFilter("nearest", "nearest")
	self.textures.waterquads = {}
	self.textures.rockquads = {}

	for i, n in ipairs(bitmasks) do
		self.textures.waterquads[n] = love.graphics.newQuad(((i-1)%8)*16, math.floor((i-1)/8)*16, 16, 16, 16*32, 16*32)
		self.textures.rockquads[n] = love.graphics.newQuad(((i-1)%8)*16, math.floor((i-1)/8)*16+16*6, 16, 16, 16*32, 16*32)
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

