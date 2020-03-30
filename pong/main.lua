
push = require 'push'

Class = require 'class'

-- our Paddle class, which stores position and dimensions for each paddle
-- and the logic for rendering them
require 'Paddle'

-- our Ball class, which isn't much different than a Paddle strcture-wise
-- but wich will mechanically function very differently
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- set the title of window
  love.window.setTitle('CS50 Pong')

  -- "seed" the RNG so that calls to random are always random
  -- use the current time, since that will vary on startup every time
  math.randomseed(os.time())

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

  -- initialize player paddles, make them global so ther can be detected
  -- by other functions and modules
  player1 = Paddle(10, 30, 5, 20)
  player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

  -- place a ball in the middle of the screen
  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

  -- game state variable used to transition between different parts of the game
  -- used for beggining, menus, main game, high score, etc.
  gameState = 'start'
end

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
    player2.dy  = 0
  end

  -- update our ball based on its DX and DY only if we're in play state
  -- scale the velocity by dt so movement is framerate-independent
  if gameState == 'play' then
    ball:update(dt)
  end

  player1:update(dt)
  player2:update(dt)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'play'
    else
      gameState = 'start'

      ball:reset()
    end
  end
end

function love.draw()
  push:apply('start')

  -- Love docs show in version 11 removals / 
  -- changes that color ranges now go from 0 to 1 instead of 0 to 255
  -- Dividing everything by 255 makes that clean ratio
  love.graphics.clear(40/255, 45/255, 52/255, 1)

  if gameState == 'start' then
    love.graphics.setFont(smallFont)
    love.graphics.printf(
      'Press enter or return to play!', -- text to render
      0, --starting X (0 because it is centered)
      20, -- starting Y (Halfway down the screen)
      VIRTUAL_WIDTH, -- number of pixels to center within
      'center' -- alignment mode, can be 'center', 'left' or 'right'
    )
  end

  -- draw score on the left and right center of screen
  -- need to switch font before displaying
  love.graphics.setFont(scoreFont)
  love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
    VIRTUAL_HEIGHT / 3)
  love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
    VIRTUAL_HEIGHT / 3)

  -- render paddle, now using class's render method
  player1:render()
  player2:render()

  --render the ball
  ball:render()

  -- function to show FPS in LOVE2D
  displayFPS()

  push:apply('end')
end

function displayFPS()
  love.graphics.setFont(smallFont)
  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end