local BloodBag = {}
BloodBag.__index = BloodBag

BloodBag.new = function (t)
    local self = setmetatable({}, BloodBag)
    self.name = "bloodBag"

    self.height = 10 * Scale
    self.width = 10 * Scale

    self.type = t or "n"

    return self
end

BloodBag.draw = function (self)
    love.graphics.setColor(0.5, 0.5, 0.5, 1)
    love.graphics.rectangle("line", 600, 600, self.width, self.height)
    love.graphics.rectangle("line", 800, 600, 8 * Scale, 8 * Scale)
end

BloodBag.update = function (self)
    
end

----------------------------------
BloodBag.drawHitbox = function ()
    local hitbox = World:newRectangleCollider(Canvas.originX + 40 * Scale, Canvas.originY + Canvas.height - 30 * Scale, 24 * Scale, 26 * Scale)
    hitbox:setType("static")
    hitbox:setCollisionClass("bloodbag")
end

return BloodBag