
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  smallFont = love.graphics.newFont('Retron2000.ttf', 10)

  scoreFont = love.graphics.newFont('Retron2000.ttf', 22)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  -- initialize score variables
  player1Score = 0
  player2Score = 0

  -- paddle positions on the Y axis (can only move up or down)
  player1Y = 30
  player2Y = VIRTUAL_HEIGHT - 50
end

function love.update(dt)
  -- player 1 movement
  if love.keyboard.isDown('w') then
    -- add negative paddle speed to current Y scaled by deltatime
    player1Y = player1Y  + -PADDLE_SPEED * dt
  elseif love.keyboard.isDown('s') then
    -- add positive paddle speed to vurrent Y scaled by deltatime
    player1Y  = player1Y + PADDLE_SPEED * dt
  end
  
  -- player 1 movement
  if love.keyboard.isDown('up') then
    -- add negative paddle speed to current Y scaled by deltatime
    player2Y = player2Y  + -PADDLE_SPEED * dt
  elseif love.keyboard.isDown('down') then
    -- add positive paddle speed to vurrent Y scaled by deltatime
    player2Y  = player2Y + PADDLE_SPEED * dt
  end

end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

function love.draw()
  push:apply('start')

  -- Love docs show in version 11 removals / 
  -- changes that color ranges now go from 0 to 1 instead of 0 to 255
  -- Dividing everything by 255 makes that clean ratio
  love.graphics.clear(40/255, 45/255, 52/255, 1)

  love.graphics.setFont(smallFont)
  love.graphics.printf(
    'Hello Pong!', -- text to render
    0, --starting X (0 because it is centered)
    20, -- starting Y (Halfway down the screen)
    VIRTUAL_WIDTH, -- number of pixels to center within
    'center' -- alignment mode, can be 'center', 'left' or 'right'
  )

  -- draw score on the left and right center of screen
  -- need to switch font before displaying
  love.graphics.setFont(scoreFont)
  love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
    VIRTUAL_HEIGHT / 3)
  love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
    VIRTUAL_HEIGHT / 3)

  -- render first paddle(left)
  love.graphics.rectangle('fill', 10, player1Y, 5, 20)

  -- render second paddle(right)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

  -- render ball(center)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

  push:apply('end')
end