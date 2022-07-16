local Bed = {}
Bed.__index = Bed

Bed.new = function (x, y, state)
    local self = setmetatable({}, Bed)
    self.name = "Bed"
    self.offset = 50
    self.width = Player[1].width / 2 + 30
    self.height = Player[1].height + 30

    self.x = (Canvas.originX + x) - self.width / 2
    self.y = (Canvas.originY + y) - self.height / 2

    self.state = state or 0

    self.collider = World:newRectangleCollider(self.x, self.y + self.offset, self.width, self.height - self.offset)
    self.collider:setObject(self)
    self.collider:setType("static")
    self.collider:setCollisionClass("bed")
    return self
end

Bed.drawTop = function (self)
    love.graphics.push()
    love.graphics.setColor(167 / 255, 199 / 255, 231 / 255)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height / 3)
    love.graphics.pop()
end

Bed.drawBottom = function (self)
    love.graphics.push()
    love.graphics.setColor(167 / 255, 199 / 255, 231 / 255)
    love.graphics.rectangle("fill", self.x, self.y + (self.height / 3), self.width, self.height * 2 / 3)
    love.graphics.pop()
end

Bed.update = function (self)
end

return Bed