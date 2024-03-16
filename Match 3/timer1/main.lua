--[[
    GD50
    timer1

    Example used to showcase a simple way of implementing a timer that affects
    some output on the screen, but with more timers to illustrate scaling.
]]

push = require 'push'

VIRTUAL_WIDTH = 284
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()
	currentSecond = 0
	secontTimer = 0
	currentSecond2 = 0
	secontTimer2 = 0
	currentSecond3 = 0
	secontTimer3 = 0
	currentSecond4 = 0
	secontTimer4 = 0
	currentSecond5 = 0
	secontTimer5 = 0

	love.graphics.setDefaultFilter('nearest', 'nearest')

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
		fullscreen = false,
		vsync = true,
		resizaable = true
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
	secontTimer = secontTimer + dt

	if secontTimer > 1 then
		currentSecond = currentSecond + 1
		secontTimer = secontTimer % 1
	end

	secontTimer2 = secontTimer2 + dt

	if secontTimer2 > 2 then
		currentSecond2 = currentSecond2 + 1
		secontTimer2 = secontTimer2 % 2
	end

	secontTimer3 = secontTimer3 + dt

	if secontTimer3 > 4 then
		currentSecond3 = currentSecond3 + 1
		secontTimer3 = secontTimer3 % 4
	end

	secontTimer4 = secontTimer4 + dt

	if secontTimer4 > 3 then
		currentSecond4 = currentSecond4 + 1
		secontTimer4 = secontTimer2 % 3
	end

	secontTimer5 = secontTimer5 + dt

	if secontTimer5 > 2 then
		currentSecond5 = currentSecond5 + 1
		secontTimer5 = secontTimer2 % 2
	end
end

function love.draw()
	push:start()
	love.graphics.printf('Timer: ' .. tostring(currentSecond) .. ' seconds (every 1)', 
		0, 68, VIRTUAL_WIDTH, 'center')
	love.graphics.printf('Timer: ' .. tostring(currentSecond2) .. ' seconds (every 2)', 
		0, 82, VIRTUAL_WIDTH, 'center')
	love.graphics.printf('Timer: ' .. tostring(currentSecond3) .. ' seconds (every 4)', 
		0, 96, VIRTUAL_WIDTH, 'center')
	love.graphics.printf('Timer: ' .. tostring(currentSecond4) .. ' seconds (every 3)', 
		0, 110, VIRTUAL_WIDTH, 'center')
	love.graphics.printf('Timer: ' .. tostring(currentSecond5) .. ' seconds (every 2)', 
		0, 124, VIRTUAL_WIDTH, 'center')
	push:finish()
end