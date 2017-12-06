sti = require "libs/sti" -- tiled library
mapinfo = require "maps" -- Imports map info from maps
controls = require "controls" -- handles all controls
maploader = require "maploader"

mapNum = 1

mx , my = "", ""
io.stdout:setvbuf('no')

-- Called ONCE at beginning of game
function love.load()
  print("starting")

  -- Sets up the game for menu cursor and crosshair
	love.mouse.setVisible(true); --for debugging purposes
	love.mouse.setGrabbed(true);

	
	maploader.init()

end

-- Draws every frame
function love.draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    map:draw()

    
end

-- Updates every frame
function love.update(dt)
  mx = love.mouse.getX()
  my = love.mouse.getY()
  
  world:update(dt)
  map:update(dt)


  
end

function love.keypressed(key) -- For when you have to press it once, if held for a extended time, use keyBindings()
  -- Esc: quick quit
  if key == "escape" then
      love.event.quit();
  end

  -- Tab: toggle window mouselock
  if key == "tab" then
 		local state = not love.mouse.isGrabbed();  -- the opposite of whatever it currently is
 		love.mouse.setGrabbed(state);
  end
end

  
