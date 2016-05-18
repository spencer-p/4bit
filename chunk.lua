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
	self.batch = love.graphics.newSpriteBatch(self.world.textures.tiles, self.size^2)
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
	elseif self.level == self.maxlevel then
		love.graphics.draw(self.batch)
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
					self.batch:add(self.world.textures.waterquads[self:getTileBitmask(x, y)], 16*(x-1), 16*(y-1))
				elseif self.depth[x][y] == 1 then
					self.batch:add(self.world.textures.rockquads[self:getTileBitmask(x, y)], 16*(x-1), 16*(y-1))
				end
			end
		end
	end
	self.level = self.level + 1
end

function Chunk:getDepth(x, y)
	-- I don't want vast compatability. Only get border tiles
	assert(x >= 0 and x <= 17 and y >= 0 and y <= 17)

	local cx, cy = 0, 0 -- Delta chunk coords
	local tx, ty = 0, 0 -- Delta tile coords

	-- x value overflow to next chunk
	if x > 16 then
		cx = 1
		tx = -16
	elseif x < 1 then
		cx = -1
		tx = 16
	end
	 
	-- y value overflow to next chunk
	if y > 16 then
		cy = 1
		ty = -16
	elseif y < 1 then
		cy = -1
		ty = 16
	end

	return self.world:get(self.x+cx, self.y+cy).depth[x+tx][y+ty]
end

function Chunk:getTileBitmask(x, y)
	local north, south, west, east, northwest, northeast, southwest, southeast, center
	center = self.depth[x][y]
	
	east = self:getDepth(x+1, y) == center
	west = self:getDepth(x-1, y) == center
	south = self:getDepth(x, y+1) == center
	southwest = self:getDepth(x-1, y+1) == center
	southeast = self:getDepth(x+1, y+1) == center
	north = self:getDepth(x, y-1) == center
	northwest = self:getDepth(x-1, y-1) == center
	northeast = self:getDepth(x+1, y-1) == center
	
	local bitmask = 0
	if north and west and northwest then bitmask = bitmask + 1 end
	if north then bitmask = bitmask + 2 end
	if north and east and northeast then bitmask = bitmask + 4 end
	if west then bitmask = bitmask + 8 end
	if east then bitmask = bitmask + 16 end
	if south and west and southwest then bitmask = bitmask + 32 end
	if south then bitmask = bitmask + 64 end
	if south and east and southeast then bitmask = bitmask + 128 end
	return bitmask
end
