-- $$DATE$$ : lun. 21 mai 2018 (16:56:48)

local x,y = 0,0
local jump_force_base = 10
local jump_force = jump_force_base
local speed = 1
local gravity = 1
local world = {}

local draw = require"draw"

function player_init(w)
  world = w
  x = 20
  y = 500
end

function player_draw()
  local r, g, b, a = love.graphics.getColor( )
  love.graphics.setColor( 0.3,0.9,0.5)
  draw.quad(x,y,10)
  love.graphics.setColor( r,g,b,a)
end

function player_get_tile_on()
  return world.get_tile(x,y)
end

function player_move(dir_x,dir_y)
  local new_x = x + (dir_x * speed)
  local new_y = y + (dir_y * speed)
  local tile = player_get_tile_on(new_x, new_y)
  if tile == 0 then
    x = new_x
    y = new_y
  end
end


function player_jump()
  speed = 5
  y = y + jump_force
  jump_force = jump_force - 2
  if jump_force < -10 then
    jump_force = jump_force_base
    speed = 1
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

return { init = player_init, draw = player_draw, move = player_move, jump = player_jump, keyb_event = player_keyboard_event, tile_on = player_get_tile_on }



