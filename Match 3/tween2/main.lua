--[[
    GD50
    tween2

    Example used to showcase a simple way of "tweening" (interpolating) some value
    over a period of time, in this case by moving Flappy Bird across the screen,
    horizontally. This example instantiates a large number of birds all moving at
    different rates to show a slightly better example than before but uses
    Timer.tween to do it; it also tweens their opacity.
]]

push = require 'push'
Timer = require 'knife.timer'

VIRTUAL_WIDTH = 284
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- length of time in seconds we want it to take to move flappy across screen
TIMER_MAX = 20

function love.load()
	flappySprite = love.graphics.newImage('flappy.png')

	birds = {}

	for i = 1, 10 do
		table.insert(birds, {
			-- all start at left side
			x = 0,

			-- random Y position within screen boundaries
			y = math.random(VIRTUAL_HEIGHT - 24),

			-- random rate between half a second and our max, floating point
            -- math.random() by itself will generate a random float between 0 and 1,
            -- so we add that to math.random(max) to get a number between 0 and 10,
            -- floating-point
			rate = math.random() + math.random(TIMER_MAX - 1),

			-- start with an opacity of 0 and fade to 255 over duration as well
			opacity = 0
		})
	end

	-- end X position for our interpolations
	endX = VIRTUAL_WIDTH - flappySprite:getWidth()

	-- iterate over all birds and tween to the endX location
	for k, bird in pairs(birds) do
		Timer.tween(bird.rate, {
			-- tween bird's X to endX over bird.rate seconds
			[bird] = {x = endX, opacity = 255}
		})
	end

	love.graphics.setDefaultFilter('nearest', 'nearest')

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
		fullscreen = false,
		vsync = true,
		resizable = true
	})
end

function love.resize(w, h)
	push:resize(w, h)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function love.update(dt)
	Timer.update(dt)
end

function love.draw()
	push:start()

	-- iterating over all birds this time, calculating based on their own rate
	for k, bird in pairs(birds) do
		love.graphics.setColor(255, 255, 255, bird.opacity)
		love.graphics.draw(flappySprite, bird.x, bird.y)
	end
	
	push:finish()
end