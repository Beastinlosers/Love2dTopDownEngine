

characterWrangler = {}



function characterWrangler.add(properties)
 local defaults = {
   x          = nil,
   y          = nil,
   name       = nil,
   cb_walkIn  = function(name) print("Walkin callback "..name.."") end, -- TODO: default walkin callback just has some kind of interface flare for INTERACTION POSSIBLE, whatever we decide that looks like
   cb_click   = function(name) print("Click callback "..name.."") end,
   player     = false,
   spritetype = 1, -- [1] default npc | [2] chair | [3] bigger npc | [4] player
   speed      = 1, -- fractional multiplier
   head       = "head_down", -- this is the direction/the name of the sprite to print
   flipHead   = 1
 }

 local characterLayer

 if properties.x          == nil then properties.x          = defaults.x          end
 if properties.y          == nil then properties.y          = defaults.y          end
 if properties.name       == nil then properties.name       = defaults.name       end
 if properties.cb_walkIn  == nil then properties.cb_walkIn  = defaults.cb_walkIn  end
 if properties.cb_click   == nil then properties.cb_click   = defaults.cb_click   end
 if properties.player     == nil then properties.player     = defaults.player     end
 if properties.speed      == nil then properties.speed      = defaults.speed      end
 if properties.spritetype == nil then properties.spritetype = defaults.spritetype end
 if properties.head       == nil then properties.head       = defaults.head       end
 if properties.flipHead   == nil then properties.flipHead   = defaults.flipHead   end

 local function convoFuncBaker(a)
   local file, table
   file, table = unpack(string.split(a, '([.]+)'))
   return function()
     --assert(fileExists('convo/'..file..'.lua'), 'convo/'..file..'.lua not found!')
     local b = require ('convo.'..file)
     assert(b[table], 'Conversation "'..table..'" not found in convo/'..file..'.lua')
     loadConvo(b[table])
   end
 end

 if type(properties.cb_walkIn) == "string" then properties.cb_walkIn = convoFuncBaker(properties.cb_walkIn) end
 if type(properties.cb_click) == "string" then properties.cb_click = convoFuncBaker(properties.cb_click) end

 if properties.player then
   characterLayer = "_you"
   properties.speed = 2
 else
   characterLayer = "_" .. properties.name
 end

 map:addCustomLayer(characterLayer, #map.layers+1)

 local layer = map.layers[characterLayer]

 local chars = require "Characters" -- needed for image purposes

 layer.sprite= {
   name = properties.name,
   x = properties.x,
   y = properties.y,
   ox = math.floor(properties.x),
   oy = math.floor(properties.y),
   head = properties.head,
   flipHead = properties.flipHead,
   isWalking = false,
   ct = 0,
   cb_walkIn = properties.cb_walkIn,
   cb_click = properties.cb_click,
   speed = properties.speed
 }
 layer.sortkind = "ch"


 function layer:draw()
   local px = self.sprite.x
   local py = self.sprite.y
   local spriteName = self.sprite.name

   if spriteName == "you" then
     spriteName = pc
     love.graphics.setColor(pcColor)

   end

   local p = chars(spriteName, self.sprite.head)
   local b = chars(spriteName, "body")

   love.graphics.draw(b, px, py, nil, .50, .50, b:getWidth()/2, b:getHeight()) -- really hacky way to get bodies
   love.graphics.draw(p, px, (py-30)-2.0*math.cos(self.sprite.ct * (math.pi * 0.5 )) + 1, nil, .85*self.sprite.flipHead, .85, p:getWidth()/2, p:getHeight())

   if drawFixtures then
     love.graphics.polygon("line", self.sprite.body:getWorldPoints(self.sprite.shape:getPoints()))
     love.graphics.circle("fill", self.sprite.x, self.sprite.y, 1)
   end

 end -- layer:draw()

 function layer:update(dt)
   --print(ct)
   --print(dt)

   if(self.sprite.isWalking == true) then
     if self.sprite.ct >= 10000 then
       self.sprite.ct = 0
     end
     self.sprite.ct = self.sprite.ct + dt*15
   end

   if(properties.spritetype == 4) and focusMode ~= "cutscene" then
     playerx, playery = 0, 0
     velocity = 800

     if focusMode == "world" then
       if input:down('fast')         then velocity = 2000 end

       if input:down('up')    then playery =  (playery - velocity) * .5 dirs = "up" end
       if input:down('left')  then playerx =   playerx - velocity      dirs = "left" end
       if input:down('down')  then playery =  (playery + velocity) * .5 dirs = "down" end
       if input:down('right') then playerx =   playerx + velocity      dirs = "right" end

       if input:down('down') or input:down('up') or input:down('left') or input:down('right') then
         self.sprite.isWalking = true
       else
         self.sprite.isWalking = false
       end

     end -- focusMode == "world"
     -- FIGURE OUT DIRECTION FOR PLAYER HERE SOMEWHERE

     if playery < 0 then self.sprite.head = "head_upr" end
     if playerx > 0 then
       self.sprite.head = "head_right"
       self.sprite.flipHead = 1
     end
     if playerx < 0 then
       self.sprite.head = "head_right"
       self.sprite.flipHead = -1
     end
     if playery > 0 then self.sprite.head = "head_down" end


     -- move the plaier
     self.sprite.body:applyForce(playerx, playery)

     -- set the sprite coordinates to the body coordinates
     self.sprite.x, self.sprite.y = self.sprite.body:getWorldCenter()
   else -- if(properties.spritetype == 4) and focusMode ~= "cutscene" then

     --------------------------------------------------------------------------------------------------------------------------
     -- NOAH FIGURE OUT DIRECTION FOR EVERYONE ELSE HERE

     -- if this sprite is a character, they might be a victim of a tween and so their fixtures should follow them along
     self.sprite.body:setPosition(self.sprite.x, self.sprite.y)
   end  -- closing if properties.spritetype == 4

   -- figure out the zlines character abutts
   self.leftBounds, self.leftZline, self.rightBounds, self.rightZline = stiWrangler.zlineBounds(self.sprite.x, self.sprite.y)

   if drawFixtures then -- TODO: Clean this mess, just for testing zlines
     self.zlineDebug = {}
     for anX=0,map.width*128 do
       table.insert(self.zlineDebug, anX)
       table.insert(self.zlineDebug, stiWrangler.cascadingZ(anX,self))
     end
   end -- if drawFixtures

   -- TODO ALEX: we need the direction in which we're moving so that we know
   -- which way to face the sprite, and the status of the given character
   -- (walking, standing to begin with) so that we know which animation loop to
   -- put them in (none or sin oscilate respectively)

 end -- layer:update(dt)

 characterWrangler.fixtureCreator(layer, properties.spritetype)

 return layer
end


function characterWrangler.remove()
end

function characterWrangler.fixtureCreator(layer, fixtureMode)
 local c = layer.sprite
 -- print_r(c)
 -- [1] Default NPC = medium fixture, not the player
 if (fixtureMode == 1) then
   c.body = love.physics.newBody(world, c.x, c.y, "dynamic")
   c.body:setLinearDamping(20)
   c.body:setFixedRotation(true)
   c.shape   = love.physics.newRectangleShape(0,0,150,150)
   c.fixture = love.physics.newFixture(c.body, c.shape)
   c.fixture:setSensor(true)
   c.fixture:setUserData({ kind="character", name=c.name})
 end

 -- [2] Smaller NPC = small fixture, not the player
 if (fixtureMode == 2) then
   c.body = love.physics.newBody(world, c.x, c.y, "dynamic")
   c.body:setLinearDamping(40)
   c.body:setFixedRotation(true)
   c.shape   = love.physics.newRectangleShape(0,0,10,10)
   c.fixture = love.physics.newFixture(c.body, c.shape)
   c.fixture:setUserData({ kind="character", name=c.name})
 end

 -- [3] Bigger NPC = big fixture, not the player
 if (fixtureMode == 3) then
   c.body = love.physics.newBody(world, c.x, c.y, "dynamic")
   c.body:setLinearDamping(40)
   c.body:setFixedRotation(true)
   c.shape   = love.physics.newRectangleShape(0,0,10,10)
   c.fixture = love.physics.newFixture(c.body, c.shape)
   c.fixture:setUserData({ kind="character", name=c.name})
 end

  -- [4] Player sprite layer
 if (fixtureMode == 4) then
   c.body = love.physics.newBody(world, c.x, c.y, "dynamic")
   c.body:setLinearDamping(40)
   c.body:setFixedRotation(true)
   c.shape   = love.physics.newRectangleShape(0,0,10,10)
   c.fixture = love.physics.newFixture(c.body, c.shape)
   c.fixture:setUserData({ kind="player", name=c.name})
 end
end -- closing function characterWrangler.fixtureCreator


function characterWrangler.dirDetector(x,y,actor)

 if map.layers["_"..actor] then
   deg = math.deg(math.atan2(x,y))
   print(actor)

   if deg > 45 and deg < 135 then
     -- set sprite to move right
     map.layers["_"..actor].sprite.head = "head_right"
     map.layers["_"..actor].sprite.flipHead = 1
     print(deg)
   end

   if deg > -135 and deg < -45 then
     -- set sprite to move left
     map.layers["_"..actor].sprite.head = "head_right"
     map.layers["_"..actor].sprite.flipHead = -1
     print(deg)
   end

   --if deg > -45 and deg < 45 then
   --  -- set sprite to move left
   --  map.layers["_"..actor].sprite.head = "head_upr"
   --  print(deg)
   --end
--
   --if deg > 135 and deg < 180 then
   --  -- set sprite to move left
   --  map.layers["_"..actor].sprite.head = "head_down"
   --  map.layers["_"..actor].sprite.flipHead = 1
   --  print(deg)
   --end

   -- if deg >
 end

end





--[=================================================[
   ___          _                 __  _
  /   |  ____  (_)___ ___  ____ _/ /_(_)___  ____
 / /| | / __ \/ / __ `__ \/ __ `/ __/ / __ \/ __ \
/ ___ |/ / / / / / / / / / /_/ / /_/ / /_/ / / / /
/_/  |_/_/ /_/_/_/ /_/ /_/\__,_/\__/_/\____/_/ /_/
                __  __     __
               / / / /__  / /___  ___  __________
              / /_/ / _ \/ / __ \/ _ \/ ___/ ___/
             / __  /  __/ / /_/ /  __/ /  (__  )
            /_/ /_/\___/_/ .___/\___/_/  /____/
                        /_/

 ]=================================================]

--[[
characterWrangler.tweens = {}

-- inCutscene  = boolian, false if character is walking around the map
-- looping     = boolian, true if the sets of coordinates repeat
-- actorLayer  = variable returned by characterWrangler.add(properties)
-- coordinates = { x, y, x1, y1, x2, y2, ... , xn, yn }
-- oncomplete  = function that runs when the walk cycle is over
function walk(inCutscene, looping, actorLayer, coordinates, oncomplete)
 local tweener, tween, tweenString
 local actor = actorLayer.sprite

 actor.isWalking = true

 assert(#coordinates%2 == 0, "Odd number of coordinate pairs for animation with "..actor.name.."!")
 table.insert(coordinates, 1, actor.y)
 table.insert(coordinates, 1, actor.x)

 -- first tween from wherever we are

 if inCutscene then
   tween = flux.to(actor, 0, { x = coordinates[1] , y = coordinates[2] }):ease('linear')
 else
   tween = worldFlux:to(actor, 0, { x = coordinates[1] , y = coordinates[2] }):ease('linear')
 end

 for i = 3, #coordinates, 2 do
   local traversalTime = math.sqrt((coordinates[i]-coordinates[i-2])^2+(coordinates[i+1]-coordinates[i-1])^2)/80*1/actor.speed
   -- print('ttime', traversalTime, coordinates[i], coordinates[i+1])
   tween = tween:after(traversalTime , { x = coordinates[i] , y = coordinates[i+1] }):ease('linear'):onstart(function() characterWrangler.dirDetector(coordinates[i]-coordinates[i-2],coordinates[i+1]-coordinates[i-1], actor.name) end) -- map.layers["_"..actor.name].face, map.layers["_"..actor.name].faceFlip =
 end

 tween = tween:oncomplete(function()
   if looping and map.layers["_"..actor.name] ~= nil then
     walk(inCutscene, looping, actorLayer, coordinates, nil, true)
     print("LOOPIN")
   elseif map.layers["_"..actor.name] ~= nil then
     actor.isWalking = false
     if oncomplete ~= nil then oncomplete() end
   end
 end)
 if not dontInsert then table.insert(characterWrangler.tweens, tween) end
 return tween
end
]]
