local Patient = {}
Patient.__index = Patient

Patient.new = function (row, state, t)
    local self = setmetatable({}, Patient)
    self.scale = ScaleHeight / 8

    --init
    self.type = t or TypeList[love.math.random(1, 4)]

    --attr
    self.name = "patient"
    self.row = row
    self.state = state
    self.height = 32 * self.scale
    self.width = 16 * self.scale

    self.holded = false

    self.x = self.state == 1 and Canvas.originX + Canvas.width - (self.width * 2 + 2.05 * self.scale) or
             self.state == 2 and Canvas.originX + Canvas.width - self.width - self.scale or
             Canvas.originX + Canvas.width
    self.y = self.row == 1 and Canvas.height / 2 - self.height / 3 - 4 * self.scale or Canvas.height / 2

    self.color = {love.math.colorFromBytes(255, 255, 0)}

    --physics
    local hitboxH = self.row == 1 and self.height * 93 / 100 or self.height * 52 / 100
    local hitboxY = self.row == 1 and self.y or self.y + self.height * 48 / 100
    self.collider = World:newRectangleCollider(self.x, hitboxY, self.width, hitboxH)
    self.collider:setFixedRotation(true)
    self.collider:setType("kinematic")
    self.collider:setCollisionClass("patient")
    self.collider:setFriction(0)
    self.collider:setObject(self)

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
        self.y + FontHeight + 2 * self.scale,
        0,
        AspetRatio,
        AspetRatio,
        Font:getWidth(self.type) / 2,
        FontHeight / 2
    )
end

Patient.drawArea = function ()
    local scale = ScaleHeight / 8
    local width = 16 * scale
    local area = World:newRectangleCollider(Canvas.originX + Canvas.width - (width * 2 + 2.05 * scale), Canvas.originY, width * 2 + 2.05 * scale, Canvas.height)
    area:setType("static")
end

Patient.update = function (self, dt)
    
end

return Patient