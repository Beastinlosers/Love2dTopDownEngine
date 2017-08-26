local sti = require "libs/sti"
local mapInfo = require "cde/maps" -- Imports mapInfo from maps
mapNum = 0;

-- Called ONCE at beginning of game
function love.load()

  -- Sets up the game for menu cursor and crosshair
	love.mouse.setVisible(true); --for debugging purposes
	love.mouse.setGrabbed(true);

	entities = {} -- Empty table for entities to pass through
	love.physics.setMeter(32) -- Set world meter size (in pixels) -> One block (32 pixels) = 1 meter
	map = sti(mapInfo[("map" .. mapNum)].mapdir, {"box2d"}, 0, 64); -- Load a map exported to Lua from Tiled
	world = love.physics.newWorld(0, 0); -- Prepare physics world with horizontal and vertical gravity
	map:box2d_init(world); -- Prepare collision objects

  -- Create a Custom Layer here
	map:addCustomLayer("Sprite Layer", 3) -- Players, enemys, dropped items
	map:addCustomLayer("UI Layer", 4)     -- Health, Ammo, boss health, etc (stuff that can't be covered by stuff happening in game)
  -- Add data to Custom Layer
	spriteLayer = map.layers["Sprite Layer"]
  -- Creates player table on the spriteLayer 
  spriteLayer.player = {
    playerImg = love.graphics.newImage("assets/sprites/playermodels/playeridle.png"),
    posX = 250,
    posY = 400,
	universalDirectionalPlayerSpeed = 0.8,
  }

  pl = spriteLayer.player;
  -- Creates rigid body collider (fixture) on player
  pl.body = love.physics.newBody(world, pl.posX, pl.posY, "dynamic");
  pl.body:setLinearDamping(40);
  pl.body:setFixedRotation(true);
  pl.shape = love.physics.newRectangleShape(0,0,10,10);
  pl.fixture = love.physics.newFixture(pl.body, pl.shape);
  pl.fixture:setUserData("player");
  
  
  world = love.physics.newWorld(0, 200, true);

  -- Draw callback for Custom Layerfunction spriteLayer:update(dt) -- Draws and updates stuff under the SPRITE LAYER (Layer 3)
  function spriteLayer:draw()
			love.graphics.draw(pl.playerImg, pl.posX, pl.posY, pl.HeadRotation, 2, 2, pl.playerImg:getWidth() / 2, pl.playerImg:getHeight() / 2);
  end
end

-- Draws Every Frame
function love.draw()
    love.graphics.print(love.timer.getFPS(), 0, 0);
    map:draw();
end

-- Updated Things Every Frame
function love.update(dt)

  map:update(dt)
  world:update(dt);
  playerMovement();
  
  if love.mouse.isDown(1) then
	-- Shooting logic will eventually go here
  end
  
  
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

  
function playerMovement() -- General player movement and player rotation
	pl.HeadRotation = math.atan2( love.mouse.getX() - pl.posX, pl.posY - love.mouse.getY() ) - math.pi / 2; -- Rotates player torwards mouse
	
	if love.keyboard.isDown("w") then pl.posY = pl.posY - pl.universalDirectionalPlayerSpeed; end
	if love.keyboard.isDown("s") then pl.posY = pl.posY + pl.universalDirectionalPlayerSpeed; end
	if love.keyboard.isDown("a") then pl.posX = pl.posX - pl.universalDirectionalPlayerSpeed; end
	if love.keyboard.isDown("d") then pl.posX = pl.posX + pl.universalDirectionalPlayerSpeed; end
end