ScoreState = Class{__includes = BaseState}

local GOLD_SCORE = 30
local SILVER_SCORE = 15
local COPPER_SCORE = 5

function ScoreState:enter(params)
  self.score = params.score
  self.copper_medal = love.graphics.newImage('assets/sprites/copper_cookie.png')
  self.silver_medal = love.graphics.newImage('assets/sprites/silver_cookie.png')
  self.gold_medal = love.graphics.newImage('assets/sprites/gold_cookie.png')
end

function ScoreState:update(dt)

  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('countdown')
  end
end

function ScoreState:render()
  love.graphics.setFont(flappyFont)
  love.graphics.printf('You lost!', 0, 24, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(mediumFont)
  love.graphics.printf('Score: ' .. tostring(self.score), 0, 60, VIRTUAL_WIDTH, 'center')
  if self.score >= GOLD_SCORE then
    love.graphics.printf('You managed to obtain a gold cookie!', 0, 80, VIRTUAL_WIDTH, 'center')
    love.graphics.draw(self.gold_medal, 210, 111)
  elseif self.score >= SILVER_SCORE then
    love.graphics.printf('You managed to obtain a silver cookie!', 0, 80, VIRTUAL_WIDTH, 'center')
    love.graphics.draw(self.silver_medal, 210, 111)
  elseif self.score >= COPPER_SCORE then
    love.graphics.printf('You managed to obtain a copper cookie!', 0, 80, VIRTUAL_WIDTH, 'center')
    love.graphics.draw(self.copper_medal, 210, 111)
  else
    love.graphics.printf("You didn't get a medal, Try again!", 0, 130, VIRTUAL_WIDTH, 'center')
  end

  love.graphics.printf('Press Enter to play again!', 0, 220, VIRTUAL_WIDTH, 'center')
end