-- $$DATE$$ : dim. 27 mai 2018 (14:53:07)

local world = require"world"
local draw = require"draw"
local player = require"player"

local keys = {}
local refresh = 1/70
local screen_width, screen_height = 0,0

function love.load()
  screen_width, screen_height = love.graphics.getDimensions()
  local tilesize = 32
  assert (world.init( "data/world.txt", screen_width, screen_height, tilesize))
  player.init(world, screen_width,screen_height, 100,450)
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
  if player_x > screen_width/2 then
    love.graphics.translate(-player_x+screen_width/2,0)
  end
  world.show()
  player.draw()
end


function love.keypressed(key, scancode, is_repeat)
  keys[scancode] = true
end

function love.keyreleased(key, scancode)
  keys[scancode] = false
end
