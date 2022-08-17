local Box = {}
Box.__index = Box

Box.new = function (t)
    local self = setmetatable({}, Box)

    self.type = t or ""
    self.current = 0
    self.max = 4

    self.width = 20 * Scale
    self.height = 26 * Scale

    self.x, self.y = 0, Canvas.originY + Canvas.height - 30 * Scale
    if Boxs[1] == nil then
        self.x = Canvas.originX + Canvas.width - 140 * Scale
        Boxs[1] = self
    elseif Boxs[2] == nil then
        self.x = Canvas.originX + Canvas.width - 120 * Scale
        Boxs[2] = self
    elseif Boxs[3] == nil then
        self.x = Canvas.originX + Canvas.width - 100 * Scale
        Boxs[3] = self
    elseif Boxs[4] == nil then
        self.x = Canvas.originX + Canvas.width - 80 * Scale
        Boxs[4] = self
    end
    self.hitbox = World:newRectangleCollider(
        self.x, self.y,
        20 * Scale,
        26 * Scale
    )
    self.hitbox:setType("static")
    self.hitbox:setCollisionClass("box")
    self.hitbox:setObject(self)

    return self
end

Box.draw = function (self)
    self:drawType()
    self:drawAmount()
end

Box.drawType = function (self)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(self.type, self.x + self.width / 2, self.y + self.height / 2 - 6 * Scale, 0, 0.5 * Scale, 0.5 * Scale, Font:getWidth(self.type) / 2, FontHeight / 2)
end

Box.drawAmount = function (self)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(self.current.."/"..self.max, self.x + self.width / 2, self.y + self.height / 2 + 6 * Scale, 0, 0.5 * Scale, 0.5 * Scale, Font:getWidth(self.current.."/"..self.max) / 2, FontHeight / 2)
end

return Box