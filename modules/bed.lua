local Bed = {}
Bed.__index = Bed

Bed.new = function (x, y, state)
    local self = setmetatable({}, Bed)
    self.scale = ScaleHeight / 8
    self.name = "bed"
    self.offset = 6 * self.scale
    self.width = 16 * self.scale + self.offset
    self.height = 32 * self.scale + self.offset

    self.x = (Canvas.originX + x) - self.width / 2
    self.y = (Canvas.originY + y) - self.height / 2

    self.state = state or 0

    self.itemOnBed = {}

    self.collider = World:newRectangleCollider(self.x, self.y, self.width, self.height)
    self.collider:setObject(self)
    self.collider:setType("static")
    self.collider:setCollisionClass("bed")
    return self
end

Bed.drawTop = function (self)
    love.graphics.setColor(love.math.colorFromBytes(145, 148, 126))
    self:drawItem()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height / 3)
    self:drawType()
end

Bed.drawBottom = function (self)
    love.graphics.setColor(love.math.colorFromBytes(145, 148, 126))
    self:drawItem()
    love.graphics.rectangle("fill", self.x, self.y + self.height / 3, self.width, self.height * 2 / 3)
end

Bed.drawItem = function (self)
   if next(self.itemOnBed) then
        love.graphics.setColor(self.itemOnBed.color)
   end
end

Bed.drawType = function (self)
    if not next(self.itemOnBed) then
        return
   end
    love.graphics.setColor(1, 1, 1 ,1)
    love.graphics.print(
        self.itemOnBed.type,
        self.x + self.width / 2,
        self.y + self.height / 2,
        0,
        AspetRatio,
        AspetRatio,
        Font:getWidth(self.itemOnBed.type) / 2,
        FontHeight / 2
    )
end

Bed.update = function (self)
    
end

return Bed