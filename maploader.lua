maploader = {}
layerdata = require "layerdata"
spritedata = require "spritedata"
mapdata = require "maps"


function maploader.init()

  --Debug variables
  collisiontext = ""

  -- init all the map junk
	love.physics.setMeter(32) -- Set world meter size (in pixels) -> One block (32 pixels) = 1 meter
	map = sti(mapinfo[("map" .. mapNum)].mapdir, {"box2d"}); -- Load a map exported to Lua from Tiled
	world = love.physics.newWorld(0, 0); -- Prepare physics world with horizontal and vertical gravity
	world:setCallbacks(beginContact, endContact)

  -- Prepare collision objects and move on to init layers
  map:box2d_init(world) 
  maploader.layers(world)
  
end

function maploader.layers(world)
  print("loading map layers...")

  -- Spawn any sprites/npcs incl. player
  for k,v in pairs(spritedata) do
    --printAssociateTable(spritedat)
    spritedata[k].body = love.physics.newBody(world, spritedata[k].posX, spritedata[k].posY, spritedata[k].bodytype)
    spritedata[k].body:setLinearDamping(spritedata[k].lndamping)
    spritedata[k].shape = love.physics.newCircleShape(spritedata[k].circleshape)
    spritedata[k].fixture = love.physics.newFixture(spritedata[k].body, spritedata[k].shape)
    spritedata[k].fixture:setUserData(spritedata[k].userdata)

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
      love.graphics.draw(spritedata.player.sprite,
                         spritedata.player.posX,
                         spritedata.player.posY,
                         spritedata.player.headrotation, 
                         2, 
                         2, 
                         spritedata.player.sprite:getWidth() / 2,
                         spritedata.player.sprite:getHeight() / 2)
    end
    -- UI layer
    local function uilayerdatadraw()
      -- debug stuff
      love.graphics.print("mouse x: = " .. mx, 1100,0)
      love.graphics.print("mouse y: = " .. my, 1100,10)
      love.graphics.print("Touching: " .. collisiontext)
    end
   
    -- Define layer functions for draw
    layerdata[1].draw = spritelayerdatadraw
    layerdata[2].draw = uilayerdatadraw
  end

  --maploader.objecthandler()

  print("loaded layers...")

end

--function maploader.objecthandler()
--  print("loading object handler")
--end


-- Handle callbacks

function beginContact(a, b, coll)
  rPrint(a:getUserData())

  if (a:getUserData() == "centersensor") then 
      collisiontext = "centersensor"
  end

  if (a:getUserData() == "cornersensor") then 
      collisiontext = "cornersensor"
  end
end







--------------------------------------------------------
--  __| | ___| |__  _   _  __ _   ___| |_ _   _ / _|/ _|
-- / _` |/ _ \ '_ \| | | |/ _` | / __| __| | | | |_| |_ 
--| (_| |  __/ |_) | |_| | (_| | \__ \ |_| |_| |  _|  _|
-- \__,_|\___|_.__/ \__,_|\__, | |___/\__|\__,_|_| |_|  
--                        |___/ 

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


return maploader

