-- $$DATE$$ : jeu. 24 mai 2018 (11:49:25)

local function draw_tri_up(posx,posy,size)
  love.graphics.polygon('fill', posx,posy, posx+size, posy, posx+size, posy-size) -- pente up
end

local function draw_tri_down(posx,posy,size)
  love.graphics.polygon('fill', posx,posy-size, posx+size, posy, posx, posy) -- pente down
end

local function draw_quad(posx,posy,size,fixed_color)
  local r, g, b, a = love.graphics.getColor( )
  if not fixed_color then
    local shade = math.sin((posy/32) + (posx / 32))
    love.graphics.setColor(shade/5,shade/3,shade)
  end
  love.graphics.polygon('fill',posx,posy,posx,posy-size,posx+size,posy-size,posx+size,posy)
  love.graphics.setColor( r,g,b,a)
end

return { tri_up=draw_tri_up, tri_down=draw_tri_down, quad=draw_quad }
