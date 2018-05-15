-- $$DATE$$ : mar. 15 mai 2018 (11:13:57)

local draw = require"draw"

function love.draw()
  love.graphics.clear(0.1,0.3,0.7)
  draw.tri_up(10,100,100)
end

function love.keypressed(key, scancode, is_repeat)
  if scancode == "escape" then
    love.event.quit()
  end
end
