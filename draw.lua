-- $$DATE$$ : mar. 15 mai 2018 (11:13:17)

local function draw_tri_up(posx,posy,size)
  love.graphics.polygon('fill', posx,posy, posx+size, posy, posx+size, posy-size) -- pente up
end
  
local function draw_tri_down(posx,posy,size)
  love.graphics.polygon('fill', posx,posy-size, posx+size, posy, posx, posy) -- pente down
end

local function draw_quad(posx,posy,size)
  love.graphics.polygon('fill',posx,posy,posx,posy-size,posx+size,posy-size,posx+size,posy)
end

return { tri_up=draw_tri_up, tri_down=draw_tri_down, quad=draw_quad }
