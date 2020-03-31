push = require 'push'

Class = require 'class'

require 'Bird'

require 'Pipe'

require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('assets/sprites/background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('assets/sprites/ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

local bird = Bird()

local pipePairs = {}

local spawnTimer = 0

local lastY = -PIPE_HEIGHT + math.random(80) + 20

-- variable to pause the game when we collide with a pipe
local scrolling = true

local paused = false

local muted = false

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  math.randomseed(os.time())

  love.window.setTitle('CS50 Flappy Bird')

  smallFont = love.graphics.newFont('assets/fonts/Retron2000.ttf', 8)
  mediumFont = love.graphics.newFont('assets/fonts/Retron2000.ttf', 14)
  flappyFont = love.graphics.newFont('assets/fonts/Retron2000.ttf', 28)
  hugeFont = love.graphics.newFont('assets/fonts/Retron2000.ttf', 56)
  love.graphics.setFont(flappyFont)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })

  gStateMachine = StateMachine {
    ['title'] = function() return TitleScreenState() end,
    ['play'] = function()  return PlayState() end
  }
  gStateMachine:change('title')

  love.keyboard.keysPressed = {}
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
  if key == 'escape' then
    love.event.quit()
  end
  if key == 'p' then
    paused = not paused
  end
  if key == 'm' then
    muted = not muted
  end
end

function love.keyboard.wasPressed(key)
  if love.keyboard.keysPressed[key] then
    return true
  else
    return false
  end
end

function love.update(dt)
  if scrolling and not paused then
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
      % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
      % VIRTUAL_WIDTH

    spawnTimer = spawnTimer + dt

    if spawnTimer > 2 then

      local y = math.max(-PIPE_HEIGHT + 10,
        math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
      lastY = y

      table.insert(pipePairs, PipePair(y))
      spawnTimer = 0
    end

    bird:update(dt)

    for k, pair in pairs(pipePairs) do
      pair:update(dt)

      for l, pipe in pairs(pair.pipes) do
        if bird:collides(pipe) then
          scrolling = false
        end
      end

      if pair.x < -PIPE_WIDTH then
        pair.remove = true
      end
    end

    for k, pair in pairs(pipePairs) do
      if pair.remove then
        table.remove(pipePairs, k)
      end
    end
  end

  love.keyboard.keysPressed = {}
end

function love.draw()
  push:start()

  love.graphics.draw(background, -backgroundScroll, 0)
  
  for k, pair in pairs(pipePairs) do
    pair:render()
  end

  love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

  bird:render()

  push:finish()
end