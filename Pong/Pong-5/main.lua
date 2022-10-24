-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
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
	
	-- "seed" the RNG so that calls to random are always random
	-- use the current time, since, that will vary on startup every time
	math.randomseed(os.time())
	
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
	
	-- velocity and position variables for out ball when play starts
	ballX = VIRTUAL_WIDTH / 2 - 2
	ballY = VIRTUAL_HEIGHT / 2 - 2
	
	-- math.random return a random value between the left and right number
	ballDX = math.random(2) == 1 and 100 or -100
	ballDY = math.random(-50, 50)
	
	-- game state variable used to transiton between different parts of the game
	-- (used for beginning, menus, main game, high score list, etc.) 
	-- we will use this to determine behavior during render and update
	gameState = 'start'
end

--[[
	Runs every frame, with "dt" passed in, our delta time in seconds
	since the last frame, which LÖVE2D supplies us.
]]
function love.update(dt)
	-- player 1 movement
	if love.keyboard.isDown('w') then
		-- add negative padddle speed o current Y scaled by deltaTime
		-- now, we clamp position between the bounds of the screen
		-- math.man returns the greater of two values; 0 and player Y
		-- will ensure we don't go above it
		player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
	elseif love.keyboard.isDown('s') then
		-- add positive paddle speed to current Y scaled by deltaTime
		-- manth.min returns the lesser of two values; botton of the edge minus
		-- and player Y will ensure wee don't go below it
		player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
	end

	-- player 2 movement
	if love.keyboard.isDown('up') then
		-- add negative paddle speed to current Y scaled by deltaTime
		player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
	elseif love.keyboard.isDown('down') then
		-- add positive paddle speed to current Y scaled by deltaTime
		player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
	end
	
	-- update out ball based on its DX and DY only if we're in play state;
	-- scale the velocity by dt so movent is framerate-independent
	if gameState == 'play' then
		ballX = ballX + ballDX * dt
		ballY = ballY + ballDY * dt
	end
end


--[[
	Keyboard handling, called by LÖVE2D each frame;
	passes in the key we pressed so we can access.
]]
function love.keypressed(key)
	--key can be accessed by string name
	if key == 'escape' then
		--function LÖVE gives us to terminate applicatiion
		love.event.quit()
	elseif key == 'enter' or key == 'return' then
		if gameState == 'start' then
			gameState = 'play'
		else
			gameState = 'start'
			
			-- start balls's position in the middle of the screen
			ballX = VIRTUAL_WIDTH / 2 - 2
			ballY = VIRTUAL_HEIGHT / 2 - 2
			
			-- give ball's X and Y velocity random starting value
			-- the and/or pattern here is LUS's way of accomplishing a ternary
			-- in other programming languages like C
			ballDX = math.random(2) == 1 and 100 or -100
			ballDY = math.random(-50, 50) * 1.5
		end
	end
end

--Called each frame by LÖVE after update for drawing things to the screen once they've changed
function love.draw()
	-- begin rendering at virtual resolution
	push:apply('start')
	
	-- clear the screen with a specific color; in case, a color similar
	-- to some versions of the original Pong
	love.graphics.clear(40/255, 45/255, 52/255, 255/255)
	
		
	-- set LÖVE2D's active font to the smallFont object
	love.graphics.setFont(smallFont)
	
	if gameState == 'start' then
		--love.graphics.printf(text, x, y, [width], [align])
		love.graphics.printf('Hello Start State!', 0, 20, VIRTUAL_WIDTH, 'center')
	else
		love.graphics.printf('Hello Play State!', 0, 20, VIRTUAL_WIDTH, 'center')
	end
	
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
	love.graphics.rectangle('fill', ballX, ballY, 4, 4)
	
	-- end rendering at virtual resolution
	push:apply('end')	
end