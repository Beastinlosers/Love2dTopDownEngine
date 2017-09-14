controls = {}

function controls.player() -- General player controls
  local x, y = 0, 0
    if love.keyboard.isDown("w") then y = y - 6000 end
    if love.keyboard.isDown("s") then y = y + 6000 end
    if love.keyboard.isDown("a") then x = x - 6000 end
    if love.keyboard.isDown("d") then x = x + 6000 end

    spriteLayer.player.body:applyForce(x,y)
    -- Sync the sprite with the collision object
    spriteLayer.player.posX, spriteLayer.player.posY = spriteLayer.player.body:getWorldCenter()

    -- Allow character to rotate to follow the mouse. Can be removed if not needed
    spriteLayer.player.HeadRotation = math.atan2( love.mouse.getX() - spriteLayer.player.posX, spriteLayer.player.posY - love.mouse.getY() ) - math.pi / 2; 

end

return controls
