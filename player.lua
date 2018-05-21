-- $$DATE$$ : lun. 21 mai 2018 (21:16:21)

local x,y = 0,0
local jump_force_base = 10
local jump_force = jump_force_base
local speed_base = 0.5
local speed = speed_base
local gravity_base = 0.1
local gravity = gravity_base
local world = {}
local screen_width, screen_height

local draw = require"draw"

function player_init(w)
  world = w
  screen_width, screen_height = world.screen_dims()
  x = 20
  y = 250
end

function player_draw()
  local r, g, b, a = love.graphics.getColor( )
  love.graphics.setColor( 0.3,0.9,0.5)
  draw.quad(x,y,10)
  love.graphics.setColor( r,g,b,a)
end

function player_get_tile(x_pixel, y_pixel)
  return world.get_tile(x_pixel,y_pixel)
end

function player_move(dir_x,dir_y)
  local new_x = x + (dir_x * speed)
  local new_y = y + (dir_y * speed)
  local tile = player_get_tile(new_x, new_y)
  if tile == 0 then
    x = new_x
    y = new_y
  end
end


function player_apply_gravity()
  -- pour appliquer la gravité, il faut
  -- tester sous le joueur.
  local tile, x_tile,y_tile = player_get_tile(x,y+1)
  if tile == 0 then
    y=y+gravity
    gravity=gravity+gravity_base/2
  else
    -- se replacer sur la bonne tuile
    y = screen_height - y_tile*world.get_tilesize()
    gravity=gravity_base
  end
end


function player_jump()
  speed = speed_base*3
  y = y + jump_force
  jump_force = jump_force - 2
  if jump_force < -10 then
    jump_force = jump_force_base
    speed = speed_base
  end
end


function player_keyboard_event(keys)
  if keys["left"] then
    player_move(-1,0)
  elseif keys["right"] then
    player_move (1,0)
  end
  if keys["up"] then
    player_move (0,-1)
  elseif keys["down"] then
    player_move(0,1)
  end
  if keys["space"] then
    player_jump()
  end
end

return { init = player_init, draw = player_draw, move = player_move, jump = player_jump, keyb_event = player_keyboard_event, get_tile = player_get_tile, apply_gravity = player_apply_gravity }



