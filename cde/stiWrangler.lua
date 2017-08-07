objectHandler = {
  sensorObjects     = {},
  teleporterObjects = {},
  sensorFixture     = {},
  teleporterFixture = {}
}

function objectHandler.loadObjects(map, world)

  -- clean out all the biz from previous load
  objectHandler.sensorObjects     = {}
  objectHandler.teleporterObjects = {}

  objectHandler.sensorFixture     = {}
  objectHandler.teleporterFixture = {}

  world:setCallbacks(objectHandler.beginContact, objectHandler.endContact)

  for _, object in pairs(map.objects) do
    if object.properties.sensor == true then -- load sensor objects
      objectHandler.sensorObjects[object.name] = object
    elseif type(object.properties.teleporter) == "string" then -- load teleporter objects
      objectHandler.teleporterObjects[object.name] = object
    end
  end

end -- closed objectHandler.loadObjects(map, world)

function objectHandler.fixtureCreator()

  -- sensors
  for i,obj in pairs(objectHandler.sensorObjects) do setHotspot(obj) end

  -- teleporters
  for i,obj in pairs(objectHandler.teleporterObjects) do setTeleporter(obj) end

end -- objectHandler.fixtureCreator()

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

function setTeleporter(objOrName)
  local bod, shep, i
  if type(objOrName) == "string" then
    obj = objectHandler.teleporterObjects[objOrName]
    i = objOrName
  else
    obj = objOrName
    i = obj.name
  end
  bod = love.physics.newBody(world, obj.x, obj.y, "static")
  shep = love.physics.newRectangleShape(obj.width/2, obj.height/2+128, obj.width, obj.height)
  objectHandler.teleporterFixture[i] = love.physics.newFixture(bod, shep)
  objectHandler.teleporterFixture[i]:setUserData({kind="teleporter", name=obj.name})
  objectHandler.teleporterFixture[i]:setSensor(true)
end

function killTeleporter(name)
  objectHandler.teleporterFixture[name]:destroy()
  objectHandler.teleporterFixture[name] = nil
end

function killHotspot(name)
  objectHandler.sensorFixture[name]:destroy()
  objectHandler.sensorFixture[name] = nil
end



function objectHandler.beginContact(a, b, coll)
  local ta =  a:getUserData()
  local tb =  b:getUserData()
  -- print('TA!!', ta)
  -- print('TB!!', tb)

  if ta.kind then print("beginContact   ", ta.kind, " ", ta.name, " + ", tb.kind, " ", tb.name) end

  --Check for beginContact callbacks here

  --test hotspot beginContact
  if     ta.kind == "hotspot" and tb.kind == "player" then
    hotspot.set(ta.name, chapterInfo["map"..mapnum].cb_click, chapterInfo["map"..mapnum].cb_walkIn)

  elseif tb.kind == "hotspot" and ta.kind == "player" then
    hotspot.set(tb.name, chapterInfo["map"..mapnum].cb_click, chapterInfo["map"..mapnum].cb_walkIn)

  elseif ta.kind == "character" and tb.kind == "player" then
    -- local chars = require "Characters" -- needed for image purposes
    hotspot.set(ta.name, map.layers["_"..ta.name].sprite.cb_click, map.layers["_"..ta.name].sprite.cb_walkIn)

  elseif tb.kind == "character" and ta.kind == "player" then
    -- local chars = require "Characters" -- needed for image purposes
    hotspot.set(tb.name, map.layers["_"..tb.name].sprite.cb_click, map.layers["_"..tb.name].sprite.cb_walkIn)

  elseif ta.kind == "teleporter" and tb.kind == "player" then
    assert(teleporterinfo[ta.name], "Teleporer info missing!")
    mapnum = teleporterinfo[ta.name].landingMap
    hotspot.teleportFrom = ta.name
    hotspot.teleportTo = teleporterinfo[ta.name].to
    stiWrangler.loadMap()

  elseif tb.kind == "teleporter" and ta.kind == "player" then
    assert(teleporterinfo[tb.name], "Teleporer info missing!")
    mapnum = teleporterinfo[tb.name].landingMap
    hotspot.teleportFrom = tb.name
    hotspot.teleportTo = teleporterinfo[tb.name].to
    stiWrangler.loadMap()

  end

end -- function beginContact()



function objectHandler.endContact(a, b, coll)
  local persisting = 0
  local ta =  a:getUserData()
  local tb =  b:getUserData()

  --Check for endContact callbacks here

  if ta.kind then print("endContact   ", ta.kind, " ", ta.name, " + ", tb.kind, " ", tb.name) end

  --test hotspot endContact
  if (ta.kind == "hotspot" and tb.kind == "player") or
     (tb.kind == "hotspot" and ta.kind == "player") or
     (ta.kind == "character" and tb.kind == "player") or
     (tb.kind == "character" and ta.kind == "player") then
    hotspot.clear()
  --teleporter endContact
  elseif (ta.kind == "teleporter" or tb.kind == "teleporter") then
    -- clearing the hotspot.teleporter biz happens in level load just to be safe
  end
end -- function endContact()



-- handler for hotspot actions
hotspot = {
  contact         = false,
  callback_click  = nil,
  callback_walkIn = nil,
  name            = nil,
  teleportFrom    = nil, -- doesn't get cleared automatically!!
  teleportTo      = nil,  -- doesn't get cleared automatically!!
}

function hotspot.set(name, cb_click, cb_walkIn)
  hotspot.contact = true
  hotspot.callback_click = cb_click
  hotspot.name = name
  if cb_walkIn ~= nil then cb_walkIn(hotspot.name) end
end

function hotspot.__call()
  if hotspot.callback_click ~= nil then hotspot.callback_click(hotspot.name) end
end

function hotspot.clear()
  hotspot.contact         = false
  hotspot.callback_click  = nil
  hotspot.callback_walkIn = nil
  hotspot.name            = nil
end

setmetatable(hotspot, hotspot)
