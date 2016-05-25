--[[
	4bit - working title
	Procgen 2d world exploration.
]]

require "world"
require "overworld"
require "titlescreen"
Camera = require "hump.camera"
Gamestate = require "hump.gamestate"

function love.load()
	colors = { { 0xe0, 0xf8, 0xd0 }, { 0x88, 0xc0, 0x70 }, { 0x30, 0x68, 0x50 }, { 0x08, 0x18, 0x20 } }
	Gamestate.registerEvents()
	Gamestate.switch(titlescreen)
end

function love.draw()
	love.graphics.setColor(0xff, 0, 0)
	love.graphics.print(love.timer.getFPS())
	love.graphics.setColor(0xff, 0xff, 0xff)
end

function love.update()
--	require("lovebird.lovebird").update()
end

function love.keypressed(key)
end
