maploader = {}

function maploader.init()

	love.physics.setMeter(32) -- Set world meter size (in pixels) -> One block (32 pixels) = 1 meter
	map = sti(mapinfo[("map" .. mapNum)].mapdir, {"box2d"}, 0, 64); -- Load a map exported to Lua from Tiled
	world = love.physics.newWorld(0, 0); -- Prepare physics world with horizontal and vertical gravity
	map:box2d_init(world); -- Prepare collision objects

	maploader.layers()

end

function maploader.layers()
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

return maploader