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
MOVE_DURATION = 2

function love.load()
	flappySprite = love.graphics.newImage('flappy.png')

	-- assigning two variables at once, a Lua shortcut
	flappyX, flappyY = 0, VIRTUAL_HEIGHT / 2 - 8

	-- timer for interpolating the Y value
	timer = 0

	-- end X position for our interpolation
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
	if timer < MOVE_DURATION then
		timer = timer + dt

		-- math.min ensures we don't go past the end
        -- timer / MOVE_DURATION is a ratio that we effectively just multiply our
        -- X by each turn to make it seem as if we're moving right
		flappyX = math.min(endX, endX * (timer / MOVE_DURATION))
	end
end

function love.draw()
	push:start()
	love.graphics.draw(flappySprite, flappyX, flappyY)
	love.graphics.print(tostring(timer), 4, 4)
	push:finish()
end