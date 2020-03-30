
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT == 243

-- function love.load()
--   love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
--     fullscreen = false,
--     resizable = false,
--     vsync = true
--   })
-- end

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
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

  love.graphics.printf(
    'Hello Pong!', -- text to render
    0, --starting X (0 because it is centered)
    WINDOW_HEIGHT / 2 - 6, -- starting Y (Halfway down the screen)
    WINDOW_WIDTH, -- number of pixels to center within
    'center' -- alignment mode, can be 'center', 'left' or 'right'
  )

  push:apply('end')
end