-- $$DATE$$ : mer. 16 mai 2018 (19:19:39)

local draw = require"draw"

-- world bounds
local world_height, world_width
local world = {}
local screen_width, screen_height

local function extract_line( l, tile_per_line)
  local t = {}
  t = { l:byte(1,tile_per_line) }

  -- on complète la ligne de tuiles pour avoir au moins un écran de large
  for i = #t+1, tile_per_line do
    t[i] = 0
  end
  return t
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
      world[#world + 1] = extract_line(l, tile_per_line)
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
        dict[tile](i*ts, screen_height-num_line*ts, ts) 
      end
    end
    num_line = num_line+1
  end
end

-- origin : 1,world_height
local function get_tile_world(x,y)
  return world[world_height+1-y][x]
end

return { show_ascii = show_ascii_world, show = show_world, init = init_world, get_tile = get_tile_world }
