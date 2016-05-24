--[[
	This is the *gamestate* for the world
]]

Gamestate = require "hump.gamestate"
require "player"

overworld = {}

function overworld:init()
	love.graphics.setBackgroundColor(0xe0, 0xf8, 0xd0)
	--love.keyboard.setKeyRepeat(true)
	self.world = World("seed")
	self.height, self.width = 144
	self.scale = love.graphics.getHeight()/self.height
	self.player = Player(0, 0)
	self.camera = Camera()
	self.camera:lookAt(self.player.pos.x*self.scale, self.player.pos.y*self.scale)
end

function overworld:draw()
	self.camera:attach()
	love.graphics.scale(self.scale)
	self.world:draw(self.player:chunk())
	self.player:draw()
	self.camera:detach()
end

function overworld:update(dt)
	self.camera:lookAt(self.player.pos.x*self.scale, self.player.pos.y*self.scale)
	self.world:update(dt, self.player:chunk())
	self.player:update(dt)
end

function overworld:keypressed(key)
	self.player:keypressed(key)
end

function overworld:keyreleased(key)
	self.player:keyreleased(key)
end
