controls = {}

function controls.player() -- General player controls
	
	-- Rotates player torwards mouse
	pl.HeadRotation = math.atan2( love.mouse.getX() - pl.posX, pl.posY - love.mouse.getY() ) - math.pi / 2; 
	
	if love.keyboard.isDown("w") then pl.posY = pl.posY - pl.universalDirectionalPlayerSpeed; end
	if love.keyboard.isDown("s") then pl.posY = pl.posY + pl.universalDirectionalPlayerSpeed; end
	if love.keyboard.isDown("a") then pl.posX = pl.posX - pl.universalDirectionalPlayerSpeed; end
	if love.keyboard.isDown("d") then pl.posX = pl.posX + pl.universalDirectionalPlayerSpeed; end

	if love.mouse.isDown(1) then print("action button was pressed") end
  

end

return controls
