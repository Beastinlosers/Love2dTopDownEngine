return {
    spritedata = {

      player = {
        sprite = love.graphics.newImage("assets/sprites/playermodels/playeridle.png"),
        posX = 250,
        posY = 400,
        body, 
        shape,
        fixture,
        lndamping = 60,
        rot = true,
        circleshape = 10,
        bodytype = "dynamic",
        userdata = "player",
        state = 0, -- 0 = Visible, 1 = Invisible&Disabled, 2 = Disabled&Visible (for menus, etc)

      },
    },
}