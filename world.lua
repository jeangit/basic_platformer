-- $$DATE$$ : lun. 21 mai 2018 (21:11:56)

local draw = require"draw"

-- world bounds
local world_height, world_width
local world = {}
local screen_width, screen_height

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


local function init_world( mapname, tilesize)
  world.tilesize = tilesize
  local is_ok = true
  screen_width, screen_height = love.graphics.getDimensions()
  local tile_per_line = screen_width/tilesize

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
  local dict = { [43] = draw.quad, [47] = draw.tri_up, [92] = draw.tri_down }
  local num_line = 0
  local ts = world.tilesize
  --local start = screen_height+world_height*tilesize
  for line = world_height,1,-1 do
    for i,tile in ipairs(world[line]) do
      if (dict[tile]) then
        dict[tile]((i-1)*ts, screen_height-num_line*ts, ts)
      end
    end
    num_line = num_line+1
  end
end

-- origin : 1,world_height
local function get_tile_world(x_pixel,y_pixel)
  local ts = world.tilesize
  local y_tile = math.floor( (screen_height - y_pixel) / ts ) 
  local x_tile = math.floor( x_pixel / ts ) + 1
  local tile = world[world_height-y_tile][x_tile]
  --print(x_tile, y_tile, tile)
  return tile, x_tile, y_tile+1
end

local function get_tilesize_world()
  return world.tilesize
end

local function get_screen_dims_in_pixels()
  return screen_width, screen_height
end


return { show_ascii = show_ascii_world, show = show_world, init = init_world, get_tile = get_tile_world, get_tilesize = get_tilesize_world, screen_dims = get_screen_dims_in_pixels }
