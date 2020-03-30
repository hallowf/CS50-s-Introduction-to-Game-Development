
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

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

  -- paddle positions on the Y axis (can only move up or down)
  player1Y = 30
  player2Y = VIRTUAL_HEIGHT - 50

  -- velocity and position variables for ball when game starts
  ballX = VIRTUAL_WIDTH / 2 - 2
  ballY = VIRTUAL_HEIGHT / 2 - 2

  -- math.random returns a random value between the left and right number
  ballDX = math.random(2) == 1 and 100 or -100
  ballDY = math.random(-50, 50)

  -- game state variable used to transition between different parts of the game
  -- used for beggining, menus, main game, high score, etc.
  gameState = 'start'
end

function love.update(dt)
  -- player 1 movement
  if love.keyboard.isDown('w') then
    -- add negative paddle speed to current Y scaled by deltatime
    -- now we clamp our position between the two bounds of the screen
    -- math.max returns the greater of two values: 0 and player Y
    -- will ensure we don't go above it
    player1Y = math.max(0, player1Y  + -PADDLE_SPEED * dt)
  elseif love.keyboard.isDown('s') then
    -- add positive paddle speed to vurrent Y scaled by deltatime
    -- math.min returns the lesser of two values
    player1Y  = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
  end
  
  -- player 2 movement
  if love.keyboard.isDown('up') then
    -- add negative paddle speed to current Y scaled by deltatime
    player2Y = math.max(0, player2Y  + -PADDLE_SPEED * dt)
  elseif love.keyboard.isDown('down') then
    -- add positive paddle speed to vurrent Y scaled by deltatime
    player2Y  = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
  end

  -- update our ball based on its DX and DY only if we're in play state
  -- scale the velocity by dt so movement is framerate-independent
  if gameState == 'play' then
    ballX = ballX + ballDX * dt
    ballY = ballY + ballDY * dt
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'play'
    else
      gameState = 'start'

      -- start ball's position in middle of screen
      ballX = VIRTUAL_WIDTH / 2 - 2
      ballY = VIRTUAL_HEIGHT / 2 - 2

      -- given ball's x and y velocity a random starting value
      -- the and/or pattern is Lua's way of accomplishing a ternary
      -- in other programming languages like C
      ballDX = math.random(2) == 1 and 100 or -100
      ballDY = math.random(-50, 50) * 1.5
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

  -- render first paddle(left)
  love.graphics.rectangle('fill', 10, player1Y, 5, 20)

  -- render second paddle(right)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

  -- render ball(center)
  love.graphics.rectangle('fill', ballX, ballY, 4, 4)

  push:apply('end')
end