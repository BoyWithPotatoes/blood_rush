local Patient = {}
Patient.__index = Patient

local downArea, upArea

Patient.new = function (row, state, t)
    local self = setmetatable({}, Patient)

    --init
    self.type = t or TypeList[love.math.random(1, 4)]

    --attr
    self.name = "patient"
    self.row = row
    self.state = state
    self.height = 32 * Scale
    self.width = 16 * Scale

    self.holded = false

    self.x = self.state == 1 and Canvas.originX + Canvas.width - (self.width * 2 + 2.05 * Scale) or
             self.state == 2 and Canvas.originX + Canvas.width - self.width - Scale or
             Canvas.originX + Canvas.width
    self.y = self.row == 1 and Canvas.height / 2 - self.height / 3 - 4 * Scale or Canvas.height / 2

    self.color = {love.math.colorFromBytes(255, 255, 0)}

    --physics

    return self
end

Patient.draw = function (self)
    self:drawDebug()
end

Patient.drawDebug = function (self)
    if self.holded then
        return
    end
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    self:drawType()
end

Patient.drawType = function (self)
    love.graphics.setColor(1, 1, 1 ,1)
    love.graphics.print(
        self.type,
        self.x + self.width / 2 ,
        self.y + FontHeight + 2 * Scale,
        0,
        AspetRatio,
        AspetRatio,
        Font:getWidth(self.type) / 2,
        FontHeight / 2
    )
end

------------------------------------------------
Patient.update = function (self, dt)
end

--------------------------------------------------------------------
Patient.drawArea = function ()
    local area = World:newRectangleCollider((Canvas.originX + Canvas.width) - 36 * Scale, Canvas.originY + Canvas.height - 32 * Scale, 32 * Scale, 32 * Scale)
    area:setType("static")
    area:setCollisionClass("patient")
end

return Patient