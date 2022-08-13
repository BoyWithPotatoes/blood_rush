local Bin = {}
Bin.__index = Bin

Bin.new = function (t)
    local self = setmetatable({}, Bin)
    self.name = "bin"

    self.height = 10 * Scale
    self.width = 10 * Scale

    return self
end

Bin.draw = function (self)
    love.graphics.setColor(0.5, 0.5, 0.5, 1)
    love.graphics.rectangle("line", 600, 600, self.width, self.height)
    love.graphics.rectangle("line", 800, 600, 8 * Scale, 8 * Scale)
end

Bin.update = function (self)
    
end

----------------------------------
Bin.drawHitbox = function ()
    local hitbox = World:newRectangleCollider(Canvas.originX + Canvas.width - 64 * Scale, Canvas.originY + Canvas.height - 30 * Scale, 24 * Scale, 26 * Scale)
    hitbox:setType("static")
    hitbox:setCollisionClass("bin")
end

return Bin