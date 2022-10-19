push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WODTH = 432
VIRTUAL_HEIGHT = 243

--Used for initializing game state at the very beginning of program execution
--Overwrite to give behavior
function love.load()
	
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	push:setupScreen(VIRTUAL_WODTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
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
	--love.graphics.printf(text, x, y, [width], [align])
	love.graphics.printf('Hello Pong!', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WODTH, 'center')
	
	-- end rendering at virtual resolution
	push:apply('end')	
end