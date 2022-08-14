local Bin = {}
Bin.__index = Bin

Bin.new = function (t)
    local self = setmetatable({}, Bin)
    self.name = "bin"

    return self
end

Bin.draw = function (self)
    
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