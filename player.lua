-- $$DATE$$ : lun. 28 mai 2018 (16:28:29)

local x,y = 0,0

local player_size = 10
local player_middle = player_size/2
local jump_force_max = 50
local jump_force = 0
local is_jumping = false
local speed_base = 1 -- essayer avec des valeurs non multiples de tilesize
local speed = speed_base
local gravity_base = 0.9 -- doit être inférieur à 1 pour éviter un problème de scintillement
local gravity = gravity_base

local right_slope=47 -- /
local left_slope=92 -- \
local world = {}
local tilesize -- récupéré de « world »
local screen_width, screen_height = 0,0

local draw = require"draw"

function player_init(w, screen_w,screen_h, start_x,start_y)
  world = w
  tilesize = world.get_tilesize()
  screen_width = screen_w
  screen_height = screen_h
  x = start_x
  y = start_y
end

function player_draw()
  local r, g, b, a = love.graphics.getColor( )
  love.graphics.setColor( 0.3,0.9,0.5)
  draw.quad(x, y, player_size, math.pi/4)
  love.graphics.setColor( r,g,b,a)
end

function player_get_tile(x_pixel, y_pixel)
  return world.get_tile(x_pixel,y_pixel)
end

function player_move(dir_x,dir_y)

  local new_x = x + (dir_x * speed)
  local new_y = y + (dir_y * speed)

  x = new_x
  y = new_y

end


function player_apply_gravity()
  local slopes = {
    [right_slope] = function() return (x+player_middle)%tilesize end,
    [left_slope] = function() return tilesize-((x+player_middle)%tilesize) end
  }

  -- le joueur est peut-être en train de sauter
  if is_jumping then
    --print("jump")
    jump_force = jump_force - jump_force/4
    if jump_force < 1 then
      jump_force = 0
      speed = speed_base
      is_jumping = false
    else
      y = y - jump_force
    end
  end


  -- application systématique de la gravité
  y=y+gravity
  gravity=gravity+gravity_base/2
  -- test y+1 : serons-nous dans une brique après prochaine application de la gravité ?
  -- ( si oui: y-1 -> workaround anti-scintillement du joueur )
  if player_get_tile(x+player_middle,y+1)~=0 then y=y-gravity_base end

  -- y-1 pour tester la tuile incrite dans la bounding-box du joueur
  local tile, x_tile,y_tile = player_get_tile(x+player_middle, y-1)
  if tile ~= 0 then
    y = screen_height - y_tile*world.get_tilesize()

    local fx_slope = slopes[tile]
    if fx_slope then
      local ajustement = fx_slope()
      --if ajustement==0 then ajustement=-1 end
      --print(ajustement)
      -- le « + tilesize » sert à le remettre à la base de la tuile pentue
      y = y + tilesize - ajustement
    end
    gravity=gravity_base
  end
end


function player_jump()
  -- on ne peut sauter que si on n'est pas déjà en train de
  -- le faire, et que si on se trouve sur une tuile solide
  if not is_jumping and player_get_tile(x+player_middle, y+1) ~= 0 then
    speed = speed_base*3
    is_jumping = true
    jump_force = jump_force_max
  end
end


function player_keyboard_event(keys)
  if keys["left"] then
    player_move(-1,0)
  elseif keys["right"] then
    player_move (1,0)
    -- keys["right"]=false -- debug pour avancer pixel par pixel
  end
  if keys["up"] then
    player_move (0,-1)
  elseif keys["down"] then
    player_move(0,1)
  end
  if keys["space"] then
    player_jump()
  end

  if keys["rshift"] or keys["lshift"] then
    -- SAUVAGERIE! (c'est pour débugger, chef!)
    keys["right"]=false
    keys["left"]=false
  end
end

local function player_getpos()
  return x,y
end


return { init = player_init, draw = player_draw, move = player_move, getpos = player_getpos, jump = player_jump, keyb_event = player_keyboard_event, get_tile = player_get_tile, apply_gravity = player_apply_gravity }



