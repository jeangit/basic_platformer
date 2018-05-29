-- $$DATE$$ : mar. 29 mai 2018 (18:35:38)

local function draw_tri_up(posx,posy,size)
  love.graphics.polygon('fill', posx,posy, posx+size, posy, posx+size, posy-size) -- pente up
end

local function draw_tri_down(posx,posy,size)
  love.graphics.polygon('fill', posx,posy-size, posx+size, posy, posx, posy) -- pente down
end


local function draw(posx,posy,size,draw_fx,fixed_color)
  local r, g, b, a = love.graphics.getColor( )
  local shade
  if fixed_color == nil then
    shade = math.sin((posy/32) + (posx / 32))
  else
    shade = math.abs(math.sin(fixed_color/8))
  end
  love.graphics.setColor(shade/3,shade/2,shade/1)
  draw_fx(posx,posy,size)
  love.graphics.setColor( r,g,b,a)
end

local function draw_quad(posx,posy,size,fixed_color)
  local draw_fx = function(posx,posy,size)
    love.graphics.polygon('fill',posx,posy,posx,posy-size,posx+size,posy-size,posx+size,posy)
   end
  draw( posx, posy, size, draw_fx ,fixed_color)
end

local function draw_ladder(posx,posy,size,fixed_color)
  local draw_fx = function(posx,posy,size)
    love.graphics.polygon('fill',posx,posy,posx,posy-size/2,posx+size,posy-size/2,posx+size,posy)
  end
  draw( posx, posy, size, draw_fx, fixed_color)
end

return { tri_up=draw_tri_up, tri_down=draw_tri_down, quad=draw_quad, ladder = draw_ladder }
