--[[
	This is the *gamestate* for the world
]]

Gamestate = require "hump.gamestate"
Timer = require "hump.timer"
require "player"

overworld = {}

function overworld:init()
	love.graphics.setBackgroundColor(colors[1])
	--love.keyboard.setKeyRepeat(true)
	self.world = World("seed")
	self.height, self.width = 144, 160
	self.scale = love.graphics.getHeight()/self.height
	self.player = Player(0, 0)
	self.camera = Camera()
	self.camera:lookAt(self.player.pos.x*self.scale, self.player.pos.y*self.scale)
	self.shader = {}
	self.shader.init = love.graphics.newShader[[
	extern number scale, radius;
	number fray = 0.5;
	float rand(vec2 co){ // Yep. I'm using this.
		return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	}
	vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords  ){
		screen_coords.x = floor(screen_coords.x/scale)*scale;
		screen_coords.y = floor(screen_coords.y/scale)*scale;
		vec4 pixel = Texel(texture, texture_coords );
		number distance = sqrt(pow(screen_coords.x-love_ScreenSize.x/2, 2) + pow(screen_coords.y-love_ScreenSize.y/2, 2));
		//number maxdistance = sqrt(pow(love_ScreenSize.x/2, 2) + pow(love_ScreenSize.y/2, 2));
		if (distance > radius) {
			pixel.a = 0;
		}
		else if (distance > fray*radius) {
			if (rand(screen_coords) < 3*(distance-fray*radius)/radius) {
				//pixel = vec4(1, 0, 0, 1);
				pixel.a = 0;
			}
		}
		return pixel * color;
	}
	]]
	self.shader.init:send("scale", self.scale*4)
	self.timer = Timer.new()
	self.initrad = 0
	self.timer:tween(1, self, { initrad = math.sqrt(love.graphics.getWidth()^2 + love.graphics.getHeight()^2) }, "in-quad", function() self.initrad = nil end)
end

function overworld:draw()

	self.camera:attach()
	love.graphics.scale(self.scale)

	if self.initrad then love.graphics.setShader(self.shader.init) end
	self.world:draw(self.player:chunk())
	if self.initrad then love.graphics.setShader() end

	self.player:draw()

	self.camera:detach()

end

function overworld:update(dt)
	self.camera:lookAt(self.player.pos.x*self.scale, self.player.pos.y*self.scale)
	self.world:update(dt, self.player:chunk())
	self.player:update(dt)
	self.timer:update(dt)
	if self.initrad then
		self.shader.init:send("radius", self.initrad)
	end
end

function overworld:keypressed(key)
	self.player:keypressed(key)
end

function overworld:keyreleased(key)
	self.player:keyreleased(key)
end
