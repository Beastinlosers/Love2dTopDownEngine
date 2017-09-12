maploader = {}

function maploader.init()

	love.physics.setMeter(32) -- Set world meter size (in pixels) -> One block (32 pixels) = 1 meter
	map = sti(mapinfo[("map" .. mapNum)].mapdir, {"box2d"}, 0, 64); -- Load a map exported to Lua from Tiled
	world = love.physics.newWorld(0, 0); -- Prepare physics world with horizontal and vertical gravity
	map:box2d_init(world); -- Prepare collision objects

	maploader.layers(world)

end

function maploader.layers(world)
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
    body,
    shape,
    fixture,
	  universalDirectionalPlayerSpeed = 0.8,
  }

    -- Creates rigid body collider (fixture) on player
    spriteLayer.player.body = love.physics.newBody(world, spriteLayer.player.posX, spriteLayer.player.posY, "dynamic");
    spriteLayer.player.body:setLinearDamping(40);
    spriteLayer.player.body:setFixedRotation(true);
    spriteLayer.player.shape = love.physics.newRectangleShape(20,20);
    spriteLayer.player.fixture = love.physics.newFixture(spriteLayer.player.body, spriteLayer.player.shape);
    spriteLayer.player.fixture:setUserData("player");


  function spriteLayer:update(dt)
    local x, y = 0, 0
    if love.keyboard.isDown("w") then y = y - 4000 end
    if love.keyboard.isDown("s") then y = y + 4000 end
    if love.keyboard.isDown("a") then x = x - 4000 end
    if love.keyboard.isDown("d") then x = x + 4000 end

    spriteLayer.player.body:applyForce(x,y)
    spriteLayer.player.posX, spriteLayer.player.posY = spriteLayer.player.body:getWorldCenter()

    spriteLayer.player.HeadRotation = math.atan2( love.mouse.getX() - spriteLayer.player.posX, spriteLayer.player.posY - love.mouse.getY() ) - math.pi / 2; 


  end  
  

  -- Draw callback for Custom Layerfunction spriteLayer:update(dt) -- Draws and updates stuff under the SPRITE LAYER
  function spriteLayer:draw()
    -- Draw player sprite
		love.graphics.draw(spriteLayer.player.playerImg, spriteLayer.player.posX, spriteLayer.player.posY, spriteLayer.player.HeadRotation, 2, 2, spriteLayer.player.playerImg:getWidth() / 2, spriteLayer.player.playerImg:getHeight() / 2);
  end


  function maploader.objecthandler()

  end


end

return maploader