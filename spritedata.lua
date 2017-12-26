return {
      player = {
        sprite = love.graphics.newImage("assets/sprites/playermodels/playeridle.png"),
        posX = 250,
        posY = 400,
        scale = 0.5,
        body,
        shape,
        fixture,
        headrotation,
        lndamping = 60,
        rot = true,
        circleshape = 10,
        bodytype = "dynamic",
        userdata = "player",
        state = 0, -- 0 = Visible, 1 = Invisible&Disabled, 2 = Disabled&Visible (for menus, etc)
    },
}
