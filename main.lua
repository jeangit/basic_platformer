-- $$DATE$$ : mer. 16 mai 2018 (19:53:58)

local world = require"world"
local draw = require"draw"
local player = require"player"

local keys = {}


function love.load()
  local tilesize = 32
  assert (world.init( "world.txt", tilesize))
  player.init()
  --world.show_ascii()
end

function love.update()
  if keys["escape"] then love.event.quit() end
  if keys["left"] then
    player.move(-1,0)
  elseif keys["right"] then
    player.move (1,0)
  end
  if keys["space"] then
    player.jump()
  end


end


function love.draw()
  love.graphics.clear(0.1,0.3,0.7)
  world.show()
  player.draw()
end


function love.keypressed(key, scancode, is_repeat)
  keys[scancode] = true
end

function love.keyreleased(key, scancode)
  keys[scancode] = false
end
