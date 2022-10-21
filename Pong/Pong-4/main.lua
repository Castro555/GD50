push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- speed at whichwe will move our paddle; multipled by dt in update
PADDLE_SPEED = 200

--Used for initializing game state at the very beginning of program execution
--Overwrite to give behavior
function love.load()
	
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	-- more "retro-looking" font object we can use for any text
	smallFont = love.graphics.newFont('font.ttf', 8)
	
	-- larger font for drawing the score on the screen
	scoreFont = love.graphics.newFont('font.ttf', 32)
	
	-- initialize window with virtual resolution
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})
	
	-- initialize score variables, used for rendering on the screen and keeping 
	-- track of the winner
	player1score = 0
	player2Score = 0
	
	-- paddle possitions on the Y axis (they can only move up or down)
	player1Y = 30
	player2Y = VIRTUAL_HEIGHT - 50
end

--[[
	Runs every frame, with "dt" passed in, our delta time in seconds
	since the last frame, which LÖVE2D supplies us.
]]
function love.update(dt)
	-- player 1 movement
	if love.keyboard.isDown('w') then
		player1Y = player1Y + -PADDLE_SPEED * dt
	elseif love.keyboard.isDown('s') then
		player1Y = player1Y + PADDLE_SPEED * dt
	end

	-- player 2 movement
	if love.keyboard.isDown('up') then
		player2Y = player2Y + -PADDLE_SPEED * dt
	elseif love.keyboard.isDown('down') then
		player2Y = player2Y + PADDLE_SPEED * dt
	end
end

function love.keypressed(key)
	--key can be accessed by string name
	if key == 'escape' then
		--function LÖVE gives us to terminate applicatiion
		love.event.quit()
	end
end

--Called each frame by LÖVE after update for drawing things to the screen once they've changed
function love.draw()
	-- begin rendering at virtual resolution
	push:apply('start')
	
	-- clear the screen with a specific color; in case, a color similar
	-- to some versions of the original Pong
	love.graphics.clear(40, 45, 52, 0)
	
		
	-- set LÖVE2D's active font to the smallFont object
	love.graphics.setFont(smallFont)
	--love.graphics.printf(text, x, y, [width], [align])
	love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')
	
	-- draw score on the left and right center of the screen
	-- need to  switch font to draw before actually printing
	love.graphics.setFont(scoreFont)
	love.graphics.printf(tostring(player1score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH)
	love.graphics.printf(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH)
	
	-- render first paddle (left side), now using th players' Y variable
	love.graphics.rectangle('fill', 10, player1Y, 5, 20)
	
	-- render second paddle (right side)
	love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)
	
	-- render ball (center)
	love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
	
	-- end rendering at virtual resolution
	push:apply('end')	
end