WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--Used for initializing game state at the very beginning of program execution
--Overwrite to give behavior
function love.load()
	--love.window.setMode(width, height, params...)
	--table example{
	--	fullscreen = false,
	--	resizable = false,
	--	vsync = true
	--}
	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})
end

--Called each frame by LÖVE after update for drawing things to the screen once they've changed
function love.draw()
	--love.graphics.printf(text, x, y, [width], [align])
	love.graphics.printf(
		'Hello Pong!',
		0,
		WINDOW_HEIGHT / 2 - 6,
		WINDOW_WIDTH,
		'center')
end