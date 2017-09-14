maploader = {}

function maploader.init()

	love.physics.setMeter(32) -- Set world meter size (in pixels) -> One block (32 pixels) = 1 meter
	map = sti(mapinfo[("map" .. mapNum)].mapdir, {"box2d"}); -- Load a map exported to Lua from Tiled
	world = love.physics.newWorld(0, 0); -- Prepare physics world with horizontal and vertical gravity
	maploader.layers(world)
  map:box2d_init(world) -- Prepare collision objects


end

function maploader.layers(world)
  print("loading map layers")
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
  }

    -- Creates a body collider (fixture) on player
    spriteLayer.player.body = love.physics.newBody(world, spriteLayer.player.posX, spriteLayer.player.posY, "dynamic")
    spriteLayer.player.body:setLinearDamping(60)
    spriteLayer.player.body:setFixedRotation(true)
    spriteLayer.player.shape = love.physics.newCircleShape(10)
    spriteLayer.player.fixture = love.physics.newFixture(spriteLayer.player.body, spriteLayer.player.shape)
    spriteLayer.player.fixture:setUserData("player")

    maploader.objecthandler()


  function spriteLayer:update(dt) 
    controls.player()

  end  
  

  -- Draw callback for Custom Layerfunction spriteLayer:update(dt) -- Draws and updates stuff under the SPRITE LAYER
  function spriteLayer:draw()
    -- Draw player sprite
		love.graphics.draw(spriteLayer.player.playerImg, spriteLayer.player.posX, spriteLayer.player.posY, spriteLayer.player.HeadRotation, 2, 2, spriteLayer.player.playerImg:getWidth() / 2, spriteLayer.player.playerImg:getHeight() / 2);
  end

end


function maploader.objecthandler()
  print("loading object handler")

  for _, layer in ipairs(map.layers) do
      -- Entire layer
      if layer.properties.sensor == true then


end




return maploader