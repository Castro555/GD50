--[[
    GD50
    Breakout Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state the game is in when we've just started; should
    simply display "Breakout" in large text, as well as a message to press
    Enter to begin.
]]

-- the "__includes" bit here means we're going to inherit all of the methods
-- that BaseState has, so it will have empty versions of all StateMachine methods
-- even if we don't override them ourselves; handy to avoid superfluous code!
StartState = Class{__includes = BaseState}

-- whether we're hightlighted 'Start' or 'High Scores'
local highLighted = 1

function StartState:enter(params)
    self.highScores = params.highScores
end

function StartState:update(dt)
	-- taggle hightlighted option if we press an arrow up or down
	if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highLighted = highLighted == 1 and 2 or 1
        gSounds['paddle-hit']:play()
    end

    -- confirm wichever option we have selected to change screens
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()

        if highLighted == 1 then
            gStateMachine:change('serve', {
                paddle = Paddle(1),
                bricks = LevelMaker.createMap(1),
                health = 3,
                score = 0,
                highScores = self.highScores,
                level = 1
            })
        else
            gStateMachine:change('high-scores', {
                highScores = self.highScores
            })
        end
    end

    -- we no longer have this globally, so inl«clude here
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    -- title
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('BREAKOUT', 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')

    -- instructions
    love.graphics.setFont(gFonts['medium'])

    -- if  we're highlighting 1, render that option blue
    if highLighted == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf('START', 0, VIRTUAL_HEIGHT / 2 + 70,
        VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

    -- render option 2 blue if we're hightlighting that one
    if highLighted == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf('HIGH SCORES', 0, VIRTUAL_HEIGHT / 2 + 90,
        VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)
end