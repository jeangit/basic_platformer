-- $$DATE$$ : sam. 26 mai 2018 (20:13:19)

local world = require"world"
local draw = require"draw"
local player = require"player"

local keys = {}
local refresh = 1/70

function love.load()
  local tilesize = 32
  assert (world.init( "data/world.txt", tilesize))
  player.init(world)
  --world.show_ascii()
end

--local debug_x=0

local sum_dt = 0
function love.update(dt)
  if keys["escape"] then love.event.quit() end

  sum_dt = sum_dt + dt
  if sum_dt >= refresh then
    sum_dt = 0
    player.keyb_event(keys)
    player.apply_gravity()
    --debug_x = debug_x+0.1
  end
end


function love.draw()
  love.graphics.clear(0.3,0.3,0.3)
  local player_x,player_y = player.getpos()
  local pos_depart_x = 209
  world.show(player_x-pos_depart_x,0)
  player.draw()
end


function love.keypressed(key, scancode, is_repeat)
  keys[scancode] = true
end

function love.keyreleased(key, scancode)
  keys[scancode] = false
end
