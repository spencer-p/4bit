--[[
	Overworld gamestate
]]

Gamestate = require "hump.gamestate"
require "player"

overworld = {}

function overworld:init()
	love.graphics.setBackgroundColor(0x9b, 0xbc, 0x0f)
	love.keyboard.setKeyRepeat(true)
	self.world = World("seed")
	self.scale = 5
	self.player = Player(0, 0)
	self.camera = Camera()
	self.camera:lookAt(self.player.x*self.scale, self.player.y*self.scale)
end

function overworld:draw()
	self.camera:attach()
	love.graphics.scale(self.scale)
	self.world:draw(self.player:chunk())
	self.player:draw()
	self.camera:detach()
end

function overworld:update()
	self.camera:lookAt(self.player.x*self.scale*16, self.player.y*self.scale*16)
	self.world:update(self.player:chunk())
end

function overworld:keypressed(key)
	self.player:keypressed(key)
end
