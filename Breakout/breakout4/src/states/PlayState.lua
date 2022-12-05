--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
	self.paddle = Paddle()

	-- initialize ball with skin #1; differente skins = diferent sprites
	self.ball = Ball(1)

	-- gicv ball rendom starting velocity
	self.ball.dx = math.random(-200, 200)
	self.ball.dy = math.random(-50, -60)

	-- give ball position in the center
	self.ball.x = VIRTUAL_WIDTH / 2 - 4
	self.ball.y = VIRTUAL_HEIGHT - 42

	-- use the "static" createMap fiunction to generate a bricks table
	self.bricks = LevelMaker.createMap()

	self.paused = false
end

function PlayState:update(dt)
	if self.paused then
		if love.keyboard.wasPressed('space') then
			self.paused = false
			gSounds['pause']:play()
		else
			return
		end
	elseif love.keyboard.wasPressed('space') then
		self.paused = true
		gSounds['pause']:play()
		return
	end

	--update positions based on velocity
	self.paddle:update(dt)
	self.ball:update(dt)

	if self.ball:collides(self.paddle) then
		-- reverse Y velocity if collision detected between paddle and ball
		self.ball.dy = -self.ball.dy

		--
        -- tweak angle of bounce based on where it hits the paddle
        --
		
		-- if we it the paddle on its left sid while moving left...
		if  self.ball.x < self.paddle.x + (self.paddle.width / 2)  and self.paddle.dx < 0 then
			self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))

			-- else if we hit the paddle on tis right side while moving right...
		elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
			self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
		end

		gSounds['paddle-hit']:play()
	end

	-- detect collision across all bricks with the ball
	for k, brick in pairs(self.bricks) do
		
		-- only check collision if we're in play
		if brick.inPlay and self.ball:collides(brick) then
			
			-- trigger the brick's hit function, which removes it from play
			brick:hit()

			--
            -- collision code for bricks
            --
            -- we check to see if the opposite side of our velocity is outside of the brick;
            -- if it is, we trigger a collision on that side. else we're within the X + width of
            -- the brick and should check to see if the top or bottom edge is outside of the brick,
            -- colliding on the top or bottom accordingly 
            --

			-- left edge; only if we're mobing right
			if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
				
				-- flip x velocity and reset postion outside of brick
				self.ball.dx = -self.ball.dx
				self.ball.x = brick.x - 8

			-- roht edge; only check if we're moving left
			elseif self.ball.x + 6 > brick.x + brick.width  and self.ball.dx < 0 then
				
				-- flip x velocity and reset podition outside of brick
				self.ball.dx = -self.ball.dx
				self.ball.x = brick.x + 32

			-- top edge if no X coliisions, always check
			elseif self.ball.y < brick.y then

				-- flip y velocity and reset position outside of brick
				self.ball.dy = -self.ball.dy
				self.ball.y = brick.y - 8

			-- bottoom edge if no x coliisionsor top colission, last possibility
			else

				-- fli y velocity and reset position outside of brick
				self.ball.dy = -self.ball.dy
				self.ball.y = brick.y + 16
			end

			-- slightly scale the y velocity to speed up the game
			self.ball.dy = self.ball.dy * 1.02

			-- only allow colliding with one brick, for corners
			break
		end
	end

	if love.keyboard.wasPressed('escape') then
		love.event.quit()
	end
end

function PlayState:render()
	-- render bricks
	for k, brick in pairs(self.bricks) do
		brick:render()
	end

	self.paddle:render()
	self.ball:render()

	-- pause text, if paused
	if self.paused then
		love.graphics.setFont(gFonts['large'])
		love.graphics.printf('PAUSED', 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
	end
end