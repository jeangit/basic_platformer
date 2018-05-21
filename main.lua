-- $$DATE$$ : lun. 21 mai 2018 (18:37:43)

local world = require"world"
local draw = require"draw"
local player = require"player"

local keys = {}


function love.load()
  local tilesize = 32
  assert (world.init( "world.txt", tilesize))
  player.init(world)
  --world.show_ascii()
end

function love.update()
  if keys["escape"] then love.event.quit() end

  player.keyb_event(keys)
  player.apply_gravity()
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
