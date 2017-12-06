controls = {}

function controls.player() -- General player controls
  -- There's a better way to handle controls but keep it simple for now
  local x, y = 0, 0
    if love.keyboard.isDown("w") then y = y - 6000 end
    if love.keyboard.isDown("s") then y = y + 6000 end
    if love.keyboard.isDown("a") then x = x - 6000 end
    if love.keyboard.isDown("d") then x = x + 6000 end

    local playerdat = spritedata.spritedata.player

    playerdat.body:applyForce(x,y)
    -- Sync the sprite with the collision object
    playerdat.posX, playerdat.posY = playerdat.body:getWorldCenter()

    -- Allow character to rotate to follow the mouse. Can be removed if not needed
    playerdat.headrotation = math.atan2( love.mouse.getX() - playerdat.posX, playerdat.posY - love.mouse.getY() ) - math.pi / 2; 

end

return controls
