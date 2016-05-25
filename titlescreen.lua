-- [[
-- This is the gamestate for the title screen
-- ]]

Gamestate = require "hump.gamestate"

titlescreen = {}

function titlescreen:init()
	love.graphics.setBackgroundColor(colors[1])
	self.height, self.width = 144, 160
	self.scale = love.graphics.getHeight()/self.height
	self.fontimage = love.graphics.newImage("assets/font.png")
	self.fontimage:setFilter("nearest", "nearest")
	self.font = love.graphics.newImageFont(self.fontimage,
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ"..
		"abcdefghijklmnopqrstuvwxyz"..
		"#%&@$.,!?:;'\"()[]*/\\+-<=>"..
		"0123456789 "
	)
	love.graphics.setFont(self.font)
end

function titlescreen:draw()
	love.graphics.scale(self.scale)
	love.graphics.setColor(colors[4])
	love.graphics.printf("4 B I T\n\n\nfeaturing no effort\n[enter]", 0, self.height/3, self.width, 'center')
end

function titlescreen:keypressed(key)
	if key == "return" then
		Gamestate.switch(overworld)
	end
end
