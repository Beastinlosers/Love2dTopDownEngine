maploader = {}
layerdata = require "layerdata"
spritedata = require "spritedata"


function maploader.init()

	love.physics.setMeter(32) -- Set world meter size (in pixels) -> One block (32 pixels) = 1 meter
	map = sti(mapinfo[("map" .. mapNum)].mapdir, {"box2d"}); -- Load a map exported to Lua from Tiled
	world = love.physics.newWorld(0, 0); -- Prepare physics world with horizontal and vertical gravity
	maploader.layers(world)
  map:box2d_init(world) -- Prepare collision objects

end

function maploader.layers(world)
  print("loading map layers...")

  -- Spawn any sprites/npcs incl. player
  for k,v in pairs(spritedata.spritedata) do
    local spritedat = spritedata.spritedata[k]
    --printAssociateTable(spritedat)
    spritedat.body = love.physics.newBody(world, spritedat.posX, spritedat.posY, spritedat.bodytype)
    spritedat.body:setLinearDamping(spritedat.lndamping)
    spritedat.shape = love.physics.newCircleShape(spritedat.circleshape)
    spritedat.fixture = love.physics.newFixture(spritedat.body, spritedat.shape)
    spritedat.fixture:setUserData(spritedat.userdata)

  end

  -- Load any layers defined in layerdata.lua
  for i,v in ipairs(layerdata) do
    
    print("generating known layers...")
    
    -- [1] Sprite Layer | [2] UI Layer | etc 
    layerdata[i] = map:addCustomLayer (layerdata[i], layerdata[i].stacklvl) 

    -- Player movement
    local function spritelayerdataupdate(dt) 
      controls.player()
    end

    layerdata[1].update = spritelayerdataupdate
    
    -- Draw player
    local function spritelayerdatadraw()
      love.graphics.draw(spritedata.spritedata.player.sprite, spritedata.spritedata.player.posX, spritedata.spritedata.player.posY, spritedata.spritedata.player.HeadRotation, 2, 2, spritedata.spritedata.player.sprite:getWidth() / 2, spritedata.spritedata.player.sprite:getHeight() / 2)
    end

    layerdata[1].draw = spritelayerdatadraw

  end

  maploader.objecthandler()

  print("loaded layers...")

end



function maploader.objecthandler()
  print("loading object handler")

  --for _, layer in ipairs(map.layers) do
  --    -- Entire layer
  --    if layer.properties.sensor == true then
  --    end

end

function printAssociateTable(t)
  print("displaying table-------------------------------------------------------")
  for i,v in pairs(t) do
    print(v)
  end
end


return maploader