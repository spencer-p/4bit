--[[
	Chunk class for the small sections
]]

Class = require "hump.class"
require "hill"

Chunk = Class{}

function Chunk:init(w, x, y)
	self.size = 16
	self.world = w
	self.x, self.y = x, y
	self.hills = {}
	for i = 1, 32 do
		self.hills[i] = Hill(self.size)
	end
	self.heights = {}
	self.depth = {}
	for i = 1, self.size do
		self.heights[i] = {}
		self.depth[i] = {}
		for j = 1, self.size do
			self.heights[i][j] = 0
			self.depth[i][j] = 0
		end
	end
	self.level = 1
	self.maxlevel = 3
	self.waterbatch = love.graphics.newSpriteBatch(self.world.textures.water.tiles, self.size^2)
end

function Chunk:draw()
	-- Offsets for drawing
	love.graphics.push()
	love.graphics.translate(self.size*self.x*16, self.size*self.y*16)
	if self.level == 1 then
		for i, hill in ipairs(self.hills) do
			love.graphics.setColor(0xFF, 0xFF, 0xFF)
			love.graphics.points(16*(hill.x-1), 16*(hill.y-1))
			--love.graphics.circle("line", hill.x, hill.y, hill.radius)
		end
	elseif self.level == 2 then
		-- ?? lol
	elseif self.level == 3 then
		love.graphics.draw(self.waterbatch)
	end
	love.graphics.pop()
end

function Chunk:detail()
	if self.level == self.maxlevel then -- We're done
		return
	end

	for x = -1, 1 do 
		for y = -1, 1 do
			if self.world:exists(self.x+x, self.y+y) then
				if self.world:get(self.x+x, self.y+y).level < self.level then
					return -- Don't add detail if the adjacent cells aren't at our level
				end
			else
				return -- Don't add detail if the adjacent cells don't exist
			end
		end
	end

	if self.level == 1 then
		local influence = {}
		for i = -1, 1 do
			for j = -1, 1 do
				for k, hill in ipairs(self.world:get(self.x+i, self.y+j).hills) do
					for x = 1, self.size do
						for y = 1, self.size do
							local dx = i * self.size
							local dy = j * self.size
							self.heights[x][y] = self.heights[x][y] + hill:height(x-dx, y-dy)
						end
					end
				end
			end
		end
		for x = 1, self.size do
			for y = 1, self.size do
				local d = self.heights[x][y]/64
				if d > self.world.landheight then
					self.depth[x][y] = 1
				elseif d > self.world.waterheight then
					self.depth[x][y] = 0
				else
					self.depth[x][y] = -1
				end
			end
		end
	elseif self.level == 2 then
		for x = 1, self.size do
			for y = 1, self.size do
				if self.depth[x][y] == -1 then
					self.waterbatch:add(self.world.textures.water.quads[self:getTileBitmask(x, y)], 16*(x-1), 16*(y-1))
				end
			end
		end
	end
	self.level = self.level + 1
end

function Chunk:getTileBitmask(x, y)
	local up, down, left, right, center
	center = self.depth[x][y]
	-- If overflows, next chunk's edge, else just the offset in our own
	if (x + 1) > 16 then right = self.world:get(self.x+1, self.y).depth[1 ][y ] else right = self.depth[x+1][y  ] end
	if (x - 1) <  1 then left  = self.world:get(self.x-1, self.y).depth[16][y ] else left  = self.depth[x-1][y  ] end
	if (y + 1) > 16 then down  = self.world:get(self.x, self.y+1).depth[x ][1 ] else down  = self.depth[x  ][y+1] end
	if (y - 1) <  1 then up    = self.world:get(self.x, self.y-1).depth[x ][16] else up    = self.depth[x  ][y-1] end

	local bitmask = 0
	if up == center then bitmask = bitmask + 1 end
	if left == center then bitmask = bitmask + 2 end
	if right == center then bitmask = bitmask + 4 end
	if down == center then bitmask = bitmask + 8 end
	return bitmask + 1 -- Arrays in lua start at 1. whoop
end
