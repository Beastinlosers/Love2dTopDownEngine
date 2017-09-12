sti = require "libs/sti" -- tiled library
mapinfo = require "maps" -- Imports map info from maps
controls = require "controls" -- handles all controls
maploader = require "maploader"

mapNum = 0;

-- Called ONCE at beginning of game
function love.load()


  -- Sets up the game for menu cursor and crosshair
	love.mouse.setVisible(true); --for debugging purposes
	love.mouse.setGrabbed(true);

	
	maploader.init()

end

-- Draws every frame
function love.draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local tx = math.floor(-spriteLayer.player.posX + ww / 2 - 16)
    local ty = math.floor(-spriteLayer.player.posY + wh / 2 - 16)

    love.graphics.translate(tx,ty)

    love.graphics.print(love.timer.getFPS(), 0, 0)
    map:draw()
end

-- Updates every frame
function love.update(dt)
  world:update(dt)
  map:update(dt)
  --controls.player()



  
end

function love.keypressed(key) -- For when you have to press it once, if held for a extended time, use keyBindings()
  if key == "escape" then
      love.event.quit();
  end
  if key == "tab" then
 		local state = not love.mouse.isGrabbed();  -- the opposite of whatever it currently is
 		love.mouse.setGrabbed(state);
  end
end

  
