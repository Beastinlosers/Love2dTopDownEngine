maploader = {}
layerdata = require "layerdata"
spritedata = require "spritedata"
mapdata = require "maps"


function maploader.init()

	love.physics.setMeter(32) -- Set world meter size (in pixels) -> One block (32 pixels) = 1 meter
	map = sti(mapinfo[("map" .. mapNum)].mapdir, {"box2d"}); -- Load a map exported to Lua from Tiled
	world = love.physics.newWorld(0, 0); -- Prepare physics world with horizontal and vertical gravity
	world:setCallbacks(beginContact, endContact)
  maploader.layers(world)
  map:box2d_init(world) -- Prepare collision objects

end

function maploader.layers(world)
  print("loading map layers...")

  -- Spawn any sprites/npcs incl. player
  for k,v in pairs(spritedata.spritedata) do -- I should fix table redundancy
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
    
    -- Player movement and sensor handling
    local function spritelayerdataupdate(dt) 
      controls.player()


    end

     -- Define layer functions for update
    layerdata[1].update = spritelayerdataupdate

    
    -- Draw player
    local function spritelayerdatadraw()
      love.graphics.draw(spritedata.spritedata.player.sprite, spritedata.spritedata.player.posX, spritedata.spritedata.player.posY, spritedata.spritedata.player.headrotation, 2, 2, spritedata.spritedata.player.sprite:getWidth() / 2, spritedata.spritedata.player.sprite:getHeight() / 2)

    end
    -- UI layer
    local function uilayerdatadraw()
      love.graphics.print("mouse x: = " .. mx, 1100,0)
      love.graphics.print("mouse y: = " .. my, 1100,10)

      love.graphics.print("Touching")
    end
   
    -- Define layer functions for draw
    layerdata[1].draw = spritelayerdatadraw
    layerdata[2].draw = uilayerdatadraw

    
    
  end

  maploader.objecthandler()

  print("loaded layers...")

end


-- Instantiate objects stored in maps/layers
function maploader.objecthandler()
  print("loading object handler")
  
  for _, layer in ipairs(map.layers) do
    --wwrPrint(map.layers)
    --printAssociateTable(map.layers)
  end

end

-- debug stuff
function printAssociateTable(t)
  print("displaying table-------------------------------------------------------")
  for i,v in pairs(t) do
    print(v)
  end
end
-- recursive table code: https://gist.github.com/stuby/5445834#file-rprint-lua
function rPrint(s, l, i) -- recursive Print (structure, limit, indent)
  l = (l) or 100; i = i or "";  -- default item limit, indent string
  if (l<1) then print "ERROR: Item limit reached." return l-1 end

  local ts = type(s)
  if (ts ~= "table") then print (i,ts,s) return l-1 end
  print (i,ts)           -- print "table"
  for k,v in pairs(s) do  -- print "[KEY] VALUE"
    l = rPrint(v, l, i.."\t["..tostring(k).."]")
    if (l < 0) then break end
  end

  return l
end 

-- callbacks

function beginContact(a, b, coll)
  rPrint(a:getUserData())

  if (a:getUserData() == "centersensor" or b:getUserData() == "centersensor") then 
      --text = text.."\n"..a:getUserData().." collided with " .. b:getUserData()
    end
end

return maploader