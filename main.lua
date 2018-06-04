-- $$DATE$$ : lun. 04 juin 2018 (16:15:11)

local world = require"world"
local draw = require"draw"
local player_factory = require"player"

local keys = {}
local refresh = 1/70
local screen_width, screen_height = 0,0


local cam_x,cam_y = 0,0
local tilesize = 32

function gameover()

end


function love.load()
  screen_width, screen_height = love.graphics.getDimensions()
  assert (world.init( "data/world.txt", screen_width, screen_height, tilesize))
  player = player_factory.new(world, screen_width,screen_height, 400,450)
  cam_x, cam_y = player.getpos()
  --world.show_ascii()
  print(player.foo)
end


function update_camera()
  local player_x,player_y = player.getpos()
  local moving_on_x = cam_x-player_x
  local relative_x = player_x % screen_width

  --print(player_x,relative_x)
  if moving_on_x~=0 and math.abs(moving_on_x) > screen_width/4 then
      local dir_x = moving_on_x/math.abs(moving_on_x)
      cam_x = cam_x - dir_x*2
  end
   -- ne pas afficher la ligne du bas qui est une ligne «tueuse» invisible
   love.graphics.translate(-cam_x + screen_width/2,tilesize)
end


local sum_dt = 0
function love.update(dt)
  if keys["escape"] then love.event.quit() end

  sum_dt = sum_dt + dt
  if sum_dt >= refresh then
    sum_dt = 0
    player.keyboard_events(keys)
    player.apply_physic()
    if not player.is_alive then gameover() end
  end
end


function love.draw()
  love.graphics.clear(0.3,0.3,0.3)
  update_camera()
  world.show()
  player.draw()
end


function love.keypressed(key, scancode, is_repeat)
  keys[scancode] = true
end

function love.keyreleased(key, scancode)
  keys[scancode] = false
end
