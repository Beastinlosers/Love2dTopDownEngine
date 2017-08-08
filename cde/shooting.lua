shoot = {}

function shoot.create_bullet(x, y, vx, vy)
  local bullet = {
    -- Variables used for calculations
    x = x or 0,
    y = y or 0,
    vx = vx or 0,
    vy = vy or 0,
    remove = false,

    timer = 2, -- number of seconds that the bullet is around for
  }

  -- Needs to be changed. We dont calculate for velocity when moving player
  function shoot.update(dt)
    self.x = self.x + self.vx * dt;
    self.y = self.y + self.vy * dt;

    self.timer = self.timer - dt; -- When bullet is old enough, it kills itself
    if self.timer <= 0 then
      self.remove = true;
    end
  end

  function shoot.draw()  -- Draws bullet
    love.graphics.setColor(0, 255, 0); -- Sets color of bullet to zero
    love.graphics.rectangle("fill", self.x, self.y, 8, 8);
  end
end
