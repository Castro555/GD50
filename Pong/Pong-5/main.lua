-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- our Paddle class, which stores position and dimensions for each Paddle
-- and the logic for rendering them
require 'Paddle'

-- our Ball class, which isn't much different than a Paddle structure-wise
-- but which will mechanically function very differently
require 'Ball'

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
	
	-- initialize our player paddles; make them global so that they can be
	-- detected by other functions and modules
	player1 = Paddle(10, 30, 5, 20)
	player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)
	
	-- place a  ball i the middle of the screen
	ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
	
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
		player1.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown('s') then
		player1.dy = PADDLE_SPEED
	else
		player1.dy = 0
	end

	-- player 2 movement
	if love.keyboard.isDown('up') then
		player2.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown('down') then
		player2.dy = PADDLE_SPEED
	else
		player2.dy = 0
	end
	
	-- update out ball based on its DX and DY only if we're in play state;
	-- scale the velocity by dt so movent is framerate-independent
	if gameState == 'play' then
		ball:update(dt)
	end
	
	player1:update(dt)
	player2:update(dt)
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
    -- if we press enter during the start state of the game, we'll go into play mode
    -- during play mode, the ball will move in a random direction
	elseif key == 'enter' or key == 'return' then
		if gameState == 'start' then
			gameState = 'play'
		else
			gameState = 'start'
			
			-- ball's new reset method
			ball:reset()
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
	
	-- render paddles, now using their class's render method
	player1:render()
	player2:render()
	
	-- render ball using its class's render method
	ball:render()
	
	-- end rendering at virtual resolution
	push:apply('end')	
end