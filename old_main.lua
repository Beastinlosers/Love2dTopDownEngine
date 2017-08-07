local sti = require "libs/sti"
local mapInfo = require "cde/maps" -- Imports mapInfo from maps
mapNum = 0;
local gun = require "cde/gunLoadout" -- Imports gun info


function love.load()


	world = love.physics.newWorld(0, 200, true);
	-- function isDown to all easy Key input
	local isDown = love.keyboard.isDown;
	-- Grab window size
	windowWidth  = love.graphics.getWidth()
	windowHeight = love.graphics.getHeight()




	-- Set world meter size (in pixels)
	love.physics.setMeter(32) -- One block (32 pixels) = 1 meter

	-- Load a map exported to Lua from Tiled
	map = sti(mapInfo[("map" .. mapNum)].mapdir, {"box2d"}, 0, 64)

	-- Prepare physics world with horizontal and vertical gravity
	world = love.physics.newWorld(0, 0)

	-- Prepare collision objects
	map:box2d_init(world)

	-- Create a Custom Layer
	map:addCustomLayer("Sprite Layer", 3)

	-- Add data to Custom Layer
	local spriteLayer = map.layers["Sprite Layer"]

	-- spriteLayer
	spriteLayer.sprites = {
			player = {
				image = love.graphics.newImage("assets/sprites/playeridle.png"),
				x = 64,
				y = 64,
				r = 0,
				health = 100,
			}
		}
		pl = spriteLayer.sprites.player -- Sets player to pl
		pl.body = love.physics.newBody(world, pl.x, pl.y, "dynamic")
		pl.body:setLinearDamping(40)
		pl.body:setFixedRotation(true)
		pl.shape = love.physics.newRectangleShape(0,0,10,10)
		pl.fixture = love.physics.newFixture(pl.body, pl.shape)
		pl.fixture:setUserData("player")

	-- Creating variables to shorten code
	mouseX = love.mouse.getX();
	mouseY = love.mouse.getY();



	-- Update callback for Custom Layer
	function spriteLayer:update(dt)
		if isDown("w") then spriteLayer.sprites.player.y = spriteLayer.sprites.player.y -1 end; -- Move UP
		if isDown("s") then spriteLayer.sprites.player.y = spriteLayer.sprites.player.y +1 end; -- Move DOWN
		if isDown("a") then spriteLayer.sprites.player.x = spriteLayer.sprites.player.x -1 end; -- Move LEFT
		if isDown("d") then spriteLayer.sprites.player.x = spriteLayer.sprites.player.x +1 end; -- Move RIGHT





	-- Draw callback for Custom Layer
	function spriteLayer:draw()
		for _, sprite in pairs(self.sprites) do
			local x = math.floor(sprite.x)
			local y = math.floor(sprite.y)
			local r = sprite.r
			love.graphics.draw(sprite.image, x, y, r)
		end
	end
end

function love.update(dt)
	map:update(dt)
	world:update(dt);

	playerModel = love.graphics.draw(love.graphics.newImage("assets/sprites/cursor.png"), mouseX, mouseY)
	love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
	rotatePlayer(playerModel);

	--end
	love.graphics.translate(pl.x, pl.y); -- Moves Player

	-- TODO Rotation function to rotate player

end

function love.draw()
	-- Draw the map and all objects within
love.graphics.setColor(255, 255, 255)



-- Transform world


	map:draw()
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

function setHotspot(objOrName)
  local bod, shep, i
  if type(objOrName) == "string" then
    obj = objectHandler.sensorObjects[objOrName]
    i = objOrName
  else
    obj = objOrName
    i = obj.name
  end
  -- Create object bodies
  bod = love.physics.newBody(world, obj.x, obj.y ,"static")
  shep = love.physics.newRectangleShape(obj.width/2, obj.height/2+128, obj.width, obj.height)
  objectHandler.sensorFixture[i] = love.physics.newFixture(bod, shep)
  objectHandler.sensorFixture[i]:setUserData({ kind="hotspot", name=obj.name})
  objectHandler.sensorFixture[i]:setSensor(true)
end

function love.keypressed(key)
	if key == "tab" then
		local state = not love.mouse.isGrabbed()   -- the opposite of whatever it currently is
		love.mouse.setGrabbed(state)
 end

 if key == "escape" then
	 love.event.quit()
 end
 if key == "r" then
		println(gun.rifle.isEquipped);
 end
	-- body...
end
--Mouse
function love.mousemoved(x, y, dx, dy)
	if grabbed then
		player.dx = -dx
		player.dy = -dy
	end
end
-- Mouse Pressing
function love.mousepressed(x, y, button, istouch)
-- Shoots
		if button == 1 then
				love.graphics.print("button 1 pressed", 100, 100); -- For testing (doesn't work)
		end
end

local bullet = {}

function bullet.shoot()
    local speed = 20
    local dir = math.atan2(( mouseY - pl.y ), ( mouseX - pl.y ))
    local dx, dy = speed * math.cos(dir), speed * math.sin(dir)
    table.insert( bullet, { x = pl.x, y = pl.y, dx = dx, dy = dy } )
end

function bullet.update(dt)
    for i, v in ipairs( bullet ) do
        v.x = v.x + v.dx * dt
        v.y = v.y + v.dy * dt
    end
end

function rotatePlayer (player)

		local dir = math.atan2(( mouseY - pl.y ), ( mouseX - pl.y ))
		love.graphics.rotate (dir)
		--[[
		local playerPos =
		var objectPos = Camera.main.WorldToScreenPoint(transform.position);
    var dir = Input.mousePosition - objectPos;
    transform.rotation = Quaternion.Euler (Vector3(0,0,Mathf.Atan2 (dir.y,dir.x) * Mathf.Rad2Deg));

		local playerPos = pl.x, pl.y ]]

end

--[[function magUpdate()
	gun.rifle.currentMagCapacity = gun.rifle.maxMagazineSize - gun.rifle.shotsFireFromMag
end]]


function smooth(goal, current, dt)
  local diff = (goal-current+math.pi)%(2*math.pi)-math.pi --checking if there's a different between the goal and the current
  if(diff>dt)then --this means that we still need to speed up
    return current + dt
  end
  if(diff<-dt)then --and this means we need to slow down
    return current - dt
  end
  return goal --if diff equals 0 then just return goal
end
end
