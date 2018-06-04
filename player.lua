-- $$DATE$$ : lun. 04 juin 2018 (20:12:59)

local x,y = 0,0

local jump_force_max = 50
local jump_force = 0
local is_jumping = false
local speed_base = 1 -- essayer avec des valeurs non multiples de tilesize
local speed = speed_base
local gravity_base = 0.9 -- doit être inférieur à 1 pour éviter un problème de scintillement
local gravity = gravity_base

local is_alive = true


local right_slope=47 -- /
local left_slope=92 -- \
local ladder=61 -- =
local world = {}
local tilesize -- récupéré de « world »
local screen_width, screen_height = 0,0

local draw = require"draw"

local function get_player_size()

  -- TODO
  -- utiliser la taille de la bounding box

  local width,height = 10,10 -- DEBUG ! À virer par la suite !

  return width,height

end

local function player_move(dir_x,dir_y)

  local new_x = x + (dir_x * speed)
  local new_y = y + (dir_y * speed)

  x = new_x
  y = new_y

end



local function player_apply_jump()
  local player_size = get_player_size()
  local player_middle = player_size/2

  jump_force = jump_force - jump_force/4
  -- stopper le saut si le joueur va se cogner contre une tuile
  local above_player = player_get_tile(x+player_middle, y-player_size-jump_force)
  if jump_force < 1 or above_player ~= 0 then
    jump_force = 0
    speed = speed_base
    is_jumping = false
  else
    y = y - jump_force
  end
end


local function player_apply_gravity()
  local player_middle = get_player_size()/2
  local slopes = {
    [right_slope] = function() return (x+player_middle)%tilesize end,
    [left_slope] = function() return tilesize-((x+player_middle)%tilesize) end
  }


  y=y+gravity
  gravity=gravity+gravity_base/2
  -- test y+1 : serons-nous dans une brique après prochaine application de la gravité ?
  -- ( si oui: y-gravity_base -> workaround anti-scintillement du joueur )
  if player_get_tile(x+player_middle,y+1)~=0 then y=y-gravity_base end

  -- y-1 pour tester la tuile incrite dans la bounding-box du joueur
  local tile, x_tile,y_tile = player_get_tile(x+player_middle, y-1)

  -- TODO: tester si on a touché une tuile avec caractéristique particulière
  --       par exemple la tuile «tueuse» du bas de l'écran
  print (tile)
  if tile ~= 0 and tile ~= ladder then
    y = screen_height - y_tile*world.get_tilesize()

    local fx_slope = slopes[tile]
    if fx_slope then
      local ajustement = fx_slope()
      --print(ajustement)
      -- le « + tilesize » sert à le remettre à la base de la tuile pentue
      y = y + tilesize - ajustement
    end
    gravity=gravity_base
  end
end

-- cette fonction n'est appellée que quand on appuie sur le bouton de saut
-- elle n'est pas réappellée ensuite pendant que le saut est en cours.
local function player_init_jump()

  local player_middle = get_player_size()/2

  -- on ne peut sauter que si on n'est pas déjà en train de le faire,
  -- _et_ que si on se trouve sur une tuile solide (sauf échelle)
  local under_player = player_get_tile(x+player_middle, y+1)
  local on_player = player_get_tile(x+player_middle, y)
  if not is_jumping and under_player ~= 0 and on_player ~= ladder then
    speed = speed_base*3
    is_jumping = true
    jump_force = jump_force_max
  end
end




function player_get_tile(x_pixel, y_pixel)
  return world.get_tile(x_pixel,y_pixel)
end


function player_new(w, screen_w,screen_h, start_x,start_y)
  world = w
  tilesize = world.get_tilesize()
  screen_width = screen_w
  screen_height = screen_h
  x = start_x
  y = start_y

  return {
    draw = function()
      local player_size = get_player_size()
      local r, g, b, a = love.graphics.getColor( )
      love.graphics.setColor( 0.3,0.9,0.5)
      draw.quad(x, y, player_size, math.pi/4)
      love.graphics.setColor( r,g,b,a)
    end,

    get_tile = function(x_pixel, y_pixel)
      return world.get_tile(x_pixel,y_pixel)
    end,

    player_move = function(dir_x,dir_y)
      local new_x = x + (dir_x * speed)
      local new_y = y + (dir_y * speed)
      x = new_x
      y = new_y
    end,

    apply_physic = function()
      local player_width, player_height = get_player_size()
      local tiles = world.get_tiles_around(x,y, player_width,player_height)
      if is_jumping then
        player_apply_jump()
      end
      -- application systématique de la gravité sauf si échelle
       --if player_get_tile(x+player_middle,y) ~= ladder then
       if tiles.under ~= ladder then
         -- TODO: reprendre ici, et passer «tiles» à «player_apply_gravity»
         -- TODO: afficher les tuiles calculées à l'écran (et non en console)
        player_apply_gravity()
       end
    end,

    keyboard_events = function(keys)
      local allowed_move = { [0]=true, [right_slope]=true, [left_slope]=true, [ladder]=true }
      local player_size = get_player_size()
      local player_middle = player_size/2

      if keys["left"] then
        local left_tile = player_get_tile(x-1, y-player_middle)
        --if left_tile == 0 or left_tile == ladder then
        if allowed_move[left_tile] then
          player_move(-1,0)
        end
      elseif keys["right"] then
        local right_tile = player_get_tile(x+player_size, y-player_middle)
        if allowed_move[right_tile] then
          player_move (1,0)
        end
      end

      if keys["up"] then
        if player_get_tile(x+player_middle,y) == ladder then
          player_move (0,-1)
        end
      elseif keys["down"] then
        if player_get_tile(x+player_middle,y) == ladder then
          player_move(0,1)
        end
      end

      if keys["space"] then
        player_init_jump()
      end

      if keys["rshift"] or keys["lshift"] then
        -- SAUVAGERIE! (c'est pour débugger, chef!)
        keys["right"]=false
        keys["left"]=false
      end
    end,

    getpos = function()
      return x,y
    end,

    is_alive = function()
      return is_alive
    end
   }

 end


return { new = player_new }



