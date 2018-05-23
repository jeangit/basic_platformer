-- $$DATE$$ : mer. 23 mai 2018 (15:27:01)

local world = require"world"
local draw = require"draw"
local player = require"player"

local keys = {}
local refresh = 1/70

function love.load()
  local tilesize = 32
  assert (world.init( "world.txt", tilesize))
  player.init(world)
  --world.show_ascii()
end

local sum_dt = 0
function love.update(dt)
  if keys["escape"] then love.event.quit() end

  sum_dt = sum_dt + dt
  if sum_dt >= refresh then
    sum_dt = 0
    player.keyb_event(keys)
    player.apply_gravity()
  end
end


function love.draw()
  love.graphics.clear(0.3,0.3,0.3)
  world.show()
  player.draw()
end


function love.keypressed(key, scancode, is_repeat)
  keys[scancode] = true
end

function love.keyreleased(key, scancode)
  keys[scancode] = false
end
