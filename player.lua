-- $$DATE$$ : mer. 16 mai 2018 (19:58:40)

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
  print("dessine",x,y)
  draw.quad(x,y,10)
end

function player_move(dir_x,dir_y)
  x = x + (dir_x * speed)
  y = y + (dir_y * speed)
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

return { init = player_init, draw = player_draw, move = player_move, jump = player_jump }



