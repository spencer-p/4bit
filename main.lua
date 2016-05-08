--[[
	4bit - working title
	Procgen 2d world exploration.
]]

require "world"
require "overworld"
Camera = require "hump.camera"
Gamestate = require "hump.gamestate"

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(overworld)
end

function love.draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(love.timer.getFPS())
end

function love.update()
	require("lovebird.lovebird").update()
end

function love.keypressed(key)
end
