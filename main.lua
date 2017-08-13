local sti = require "libs/sti"
local mapInfo = require "cde/maps" -- Imports mapInfo from maps
mapNum = 0;
local gun = require "cde/gunLoadout"
local shooting = require "cde/shooting"
local inspect = require "libs/inspect-lua/inspect"
local testMap = require "assets/maps/testMap"

canShoot = true;
shootMax = 0.2;
shootTimer = shootMax;
bullets = {}
-- Called ONCE at beginning of game
function love.load()

  -- Sets up the game for menu cursor and crosshair
	love.mouse.setVisible(false);
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
	uiLayer = map.layers["UI Layer"]
  -- Creates player table on the spriteLayer 
  spriteLayer.player = {
    playerImg = love.graphics.newImage("assets/sprites/playermodels/playerIdle.png"),
    posX = 250,
    posY = 400,
	universalDirectionalPlayerSpeed = 2.2,
  }
  pl = spriteLayer.player;
  -- Creates rigid body collider (fixture) on player
  pl.body = love.physics.newBody(world, pl.posX, pl.posY, "dynamic");
  pl.body:setLinearDamping(40);
  pl.body:setFixedRotation(true);
  pl.shape = love.physics.newRectangleShape(0,0,10,10);
  pl.fixture = love.physics.newFixture(pl.body, pl.shape);
  pl.fixture:setUserData("player");
  
  -- Asset Loader to load and store UI elements
  uiLayer.uiArtGeneral = { -- General Art Assets
	crosshair = love.graphics.newImage("/assets/sprites/icon/crosshair.png"),
  }
  
  uiArtGeneral = uiLayer.uiArtGeneral;
  
  world = love.physics.newWorld(0, 200, true);
  bulletImage = love.graphics.newImage("/assets/sprites/icon/cursormenu.png"); 

  -- Draw callback for Custom Layerfunction spriteLayer:update(dt) -- Draws and updates stuff under the SPRITE LAYER (Layer 3)
  function spriteLayer:draw()
			love.graphics.draw(pl.playerImg, pl.posX, pl.posY, pl.HeadRotation, 2, 2, pl.playerImg:getWidth() / 2, pl.playerImg:getHeight() / 2);			
			shooting.drawBullets(); -- Draws bullets
			
			--[[for i, v in ipairs(entities) do -- Draws temporary entities from entities {}
				v:draw()
			end ]]
  end
end

function uiLayer:update(dt) -- Draws and updates stuff under the UI LAYER 		  (Layer 4)
	function uiLayer:draw()
			love.graphics.draw(uiArtGeneral.crosshair, love.mouse.getX() - uiArtGeneral.crosshair:getWidth() / 2, love.mouse.getY() - uiArtGeneral.crosshair:getHeight() / 2, 1.5, 1.5);
	end
end


-- Draws Every Frame
function love.draw()
    love.graphics.print(love.timer.getFPS(), 0, 0);

    

    map:draw();
end

-- Updated Things Every Frame
function love.update(dt)

  -- entitiesChecker();
  gunChecker();  -- Displays Appropriate Sprite based on Gun in hand
  map:update(dt)
  world:update(dt);
  playerMovement();
  shooting.tryShoot(dt);
  shooting.positionBullets(dt);
  
  if love.mouse.isDown(1) then
	--[[
   local speed = 256;
	local mx, my = love.mouse.getPosition(); -- Gets mouse position
	local angle = math.atan2(my - (pl.posY + 16), mx - (pl.posX + 16)); -- Calculates angle
	local vx, vy = math.cos(angle) * speed, -- Cos and Sin are opposites forming a circle
                   math.sin(angle) * speed;
	table.insert(entities, (shoot.create_bullet(pl.posX * 16 - 4, pl.posY * 16 -4, vx, vy))); -- TODO Problem here, not creating bullet 
	print(inspect(entities));
	print("bullet drawn");  ]]
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
  if key == "t" then wallLoader(); end -- TODO for testing remove when done
  if key == "1" then gunIsEquipedFalseGlobal(); gun.m4.isEquipped = true; end
  if key == "2" then gunIsEquipedFalseGlobal(); gun.glock.isEquipped = true; end
  if key == "3" then gunIsEquipedFalseGlobal(); gun.remington.isEquipped = true; end
  if key == "e" then gunIsEquipedFalseGlobal(); end
end

function gunChecker() -- Sees what gun is equiped to set player model
  if gun.m4.isEquipped == true then
      pl.playerImg = love.graphics.newImage("assets/sprites/playermodels/playerIdleM4.png");
  end
  if gun.glock.isEquipped == true then
    pl.playerImg = love.graphics.newImage("assets/sprites/playermodels/playerIdleGlock.png");
  end
  if gun.remington.isEquipped == true then
    pl.playerImg = love.graphics.newImage("assets/sprites/playermodels/playerIdleRemington.png");
  end
end

function gunIsEquipedFalseGlobal() -- Sets all gun.WHATEVER.isEquipped = false, then sets playerIdle.png to player 
  gun.m4.isEquipped = false;
  gun.glock.isEquipped = false;
  gun.remington.isEquipped = false;
  print("Previous equiped item unequiped");
  pl.playerImg = love.graphics.newImage("/assets/sprites/playermodels/playerIdle.png"); -- If player is idle, set pl.playerImg to playerIdle.png
end

--[[function entitiesChecker()  --Polls through entities to draw them
  for i, v in ipairs(entities) do
    if v.remove then
        table.remove(entities,i)
        i = i -1;
      else
          v:update(dt)
      end
    end
  end ]]
  
function playerMovement() -- General player movement and player rotation
	pl.HeadRotation = math.atan2( love.mouse.getX() - pl.posX, pl.posY - love.mouse.getY() ) - math.pi / 2; -- Rotates player torwards mouse
	
	if love.keyboard.isDown("w") then pl.posY = pl.posY - pl.universalDirectionalPlayerSpeed; end
	if love.keyboard.isDown("s") then pl.posY = pl.posY + pl.universalDirectionalPlayerSpeed; end
	if love.keyboard.isDown("a") then pl.posX = pl.posX - pl.universalDirectionalPlayerSpeed; end
	if love.keyboard.isDown("d") then pl.posX = pl.posX + pl.universalDirectionalPlayerSpeed; end
end

function wallCollider() -- Collapsed
	
	sensorObjects = {}
	for _, object in pairs(map.objects) do
    if object.properties.sensor == true then -- load sensor objects
      objectHandler.sensorObjects[object.name] = object
    end
  end
	  for i,obj in pairs(objectHandler.sensorObjects) do setHotspot(obj) end
end

function wallLoader() -- Possibly Temporary used to segment code for ease of use; Adds object to sensorObjects{}
	print(inspect(testMap.tilesets.tiles));
	print ("wallLoader finsihsedsafsdf");
end