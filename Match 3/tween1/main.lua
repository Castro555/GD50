--[[
    GD50
    timer2

    Example used to showcase a simple way of implementing a timer that affects
    some output on the screen, but with the Timer class provided by the Knife
    library to make our lives a whole lot easier.
]]

push = require 'push'
Timer = require 'knife.timer'

VIRTUAL_WIDTH = 284
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- length of time in seconds we want it to take to move flappy across screen
TIMER_MAX = 10

function love.load()
	flappySprite = love.graphics.newImage('flappy.png')

	birds = {}

	for i = 1, 100000 do
		table.insert(birds, {
			-- all start at left side
			x = 0,

			-- random Y position within screen boundaries
			y = math.random(VIRTUAL_HEIGHT - 24),

			-- random rate between half a second and our max, floating point
            -- math.random() by itself will generate a random float between 0 and 1,
            -- so we add that to math.random(max) to get a number between 0 and 10,
            -- floating-point
			rate = math.random() + math.random(TIMER_MAX - 1)
		})
	end

	-- timer for interpolating the Y values
	timer = 0

	endX = VIRTUAL_WIDTH - flappySprite:getWidth()

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
	if timer < TIMER_MAX then
		timer = timer + dt

		-- iterating over all birds this time, calculating based on their own rate
		for k, bird in pairs(birds) do
			
			-- math.min ensures we don't go past the end
            -- timer / MOVE_DURATION is a ratio that we effectively just multiply our
            -- X by each turn to make it seem as if we're moving rightc
			bird.x = math.min(endX, endX * (timer / bird.rate))
		end
	end
end

function love.draw()
	push:start()

	-- iterating over all birds this time, calculating based on their own rate
	for k, bird in pairs(birds) do
		love.graphics.draw(flappySprite, bird.x, bird.y)
	end

	love.graphics.print(tostring(timer), 4, 4)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 4, VIRTUAL_HEIGHT - 16)
	push:finish()
end