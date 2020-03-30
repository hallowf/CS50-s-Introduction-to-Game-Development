
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  smallFont = love.graphics.newFont('MetroRetroNF.ttf', 14)

  love.graphics.setFont(smallFont)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })
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

  love.graphics.printf(
    'Hello Pong!', -- text to render
    0, --starting X (0 because it is centered)
    20, -- starting Y (Halfway down the screen)
    VIRTUAL_WIDTH, -- number of pixels to center within
    'center' -- alignment mode, can be 'center', 'left' or 'right'
  )

  -- render first paddle(left)
  love.graphics.rectangle('fill', 10, 30, 5, 20)

  -- render second paddle(right)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)

  -- render ball(center)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

  push:apply('end')
end