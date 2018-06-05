-- $$DATE$$ : mar. 05 juin 2018 (13:46:25)

local draw = require"draw"

-- world bounds
local world_height, world_width = 0,0 --donné en tuiles
local world = {}
local screen_width, screen_height -- donné en pixels

local function init_world_extract_line( l, tile_per_line)
  local t = {}
  t = { l:byte(1,tile_per_line) }

  -- on complète la ligne de tuiles pour avoir au moins un écran de large
  for i = #t+1, tile_per_line do
    t[i] = 0
  end
  return t
end

local function init_world_check_tiles(line)
  for i = 1,#line do
    local tile = line[i]
    if tile == 32 then line[i] = 0 end
  end
end


local function init_world( mapname, screen_w, screen_h, tilesize)
  world.tilesize = tilesize
  local is_ok = true
  screen_width = screen_w
  screen_height = screen_h
  -- tile_per_line : valeur bidon suffisament grande pour charger toute la
  -- map sans se taper deux passes sur le fichier (ce qui serait possible aussi,
  -- mais vu qu'ensuite je vais parser du Tiled, et abandonner cette routine…)
  local tile_per_line = 400 --screen_width/tilesize

  local hf = io.open( mapname)
  if hf then
    for l in hf:lines() do
      -- attention, les espaces sont invisibles mais différents de 0
      world[#world + 1] = init_world_extract_line(l, tile_per_line)
      init_world_check_tiles(world[#world])
    end
    hf:close()
    world_width = #world[1]
    world_height = #world
  else
    print("map not found: " .. mapname)
    is_ok = nil
  end
  return is_ok
end

local function show_ascii_world()
  for i,v in ipairs(world) do
    print(i , unpack(v))
  end
end

-- pour l'instant, on dessine à partir de l'origine: 1,height_world
local function show_world()
  local drawfx = { [43] = draw.quad, [47] = draw.tri_up, [92] = draw.tri_down, [61] = draw.ladder }
  local num_line = 0
  local ts = world.tilesize
  --local start = screen_height+world_height*tilesize

  --[[
  local start_tile_x = math.floor(cam_x / ts) -- première tuile à lire sur une ligne
  local offset_x = cam_x % ts  -- décalage x par rapport à position caméra
  if start_tile_x <= 0 then
    if cam_x<0 then offset_x=0 end
    start_tile_x = nil
  end -- ajuster éventuellement index pour fonction «next»
--]]

  for line = world_height,1,-1 do
    local index = 0
    --for _,tile in next,world[line],start_tile_x do -- nil = 1er element, 1 = 2eme element ligne,…
    for _,tile in next,world[line],nil do -- nil = 1er element, 1 = 2eme element ligne,…
      if (drawfx[tile]) then
        --drawfx[tile]( index*ts - offset_x , screen_height-num_line*ts, ts, index+(start_tile_x or 0))
        drawfx[tile]( index*ts, screen_height-num_line*ts, ts, index)
      end
      index = index+1
    end
    num_line = num_line+1
  end
end


-- retourne la valeur de la tuile située à une coordonnée pixelesque
-- ainsi que ses coordonnées exprimées en tuiles.
-- origine : 1,world_height
local function get_tile_world(x_pixel,y_pixel)
  --print("get_tile_world", x_pixel, y_pixel)
  local ts = world.tilesize
  local y_tile = math.floor( (screen_height - y_pixel) / ts )
  local x_tile = math.floor( x_pixel / ts ) + 1

  local line = world_height-y_tile
  --print("line",line,world_height)
  --if line < world_height then
  local tile_value = world[world_height-y_tile][x_tile]
  --end
  return tile_value, x_tile, y_tile+1
end

local function get_tilesize_world()
  return world.tilesize
end

local function get_tiles_around(x,y,width,height)
  local middle_width = width/2
  local middle_height = height/2
  local tiles = {}
  tiles.under = get_tile_world( x+middle_width, y+1)
  tiles.on = get_tile_world( x+middle_width, y-1)
  tiles.left = get_tile_world( x-1, y-middle_height)
  tiles.right = get_tile_world( x+width, y-middle_height)

  --tiles.debug = get_tile_world( x+middle_width, y)

  return tiles
end


return { show_ascii = show_ascii_world, show = show_world, init = init_world, get_tile = get_tile_world, get_tiles_around = get_tiles_around ,get_tilesize = get_tilesize_world }
