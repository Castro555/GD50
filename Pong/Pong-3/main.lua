push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--Used for initializing game state at the very beginning of program execution
--Overwrite to give behavior
function love.load()
	
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	-- more "retro-looking" font object we can use for any text
	smallFont = love.graphics.newFont('font.ttf', 8)
	
	-- set LÖVE2D's active font to the smallFont object
	love.graphics.setFont(smallFont)
	
	-- initialize window with virtual resolution
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})
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
	
	--love.graphics.printf(text, x, y, [width], [align])
	love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')
	
	-- render first paddle (left side)
	love.graphics.rectangle('fill', 10, 30, 5, 20)
	
	-- render second paddle (right side)
	love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)
	
	-- render ball (center)
	love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
	
	-- end rendering at virtual resolution
	push:apply('end')	
end