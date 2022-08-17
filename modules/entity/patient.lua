local Patient = {}
Patient.__index = Patient

local area

Patient.new = function (t)
    local self = setmetatable({}, Patient)

    --init
    self.type = t or TypeList[love.math.random(1, 4)]
    --attr
    self.name = "patient"
    self.width = 16 * Scale
    self.height = 30 * Scale
    self.x = nil
    self.y = nil
    self.rotate = 0
    self.facing = "up"
    self.state = "idle"
    self.holded = false

    self.spriteSheet = Sprite.doctor[1]
    self.anim8Grid = Anim8.newGrid(32, 32, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.anim8 = {}
    self.anim8.idle = {}
    self.anim8.idle.up = Anim8.newAnimation(self.anim8Grid("1-6", 7), 0.0416667)
    self.anim8.idle.down = Anim8.newAnimation(self.anim8Grid("1-6", 1), 0.0416667)
    self.anim8.idle.left = Anim8.newAnimation(self.anim8Grid("1-6", 3), 0.0416667)
    self.anim8.idle.right = Anim8.newAnimation(self.anim8Grid("1-6", 5), 0.0416667)
    self.anim8.walk = {}
    self.anim8.walk.up = Anim8.newAnimation(self.anim8Grid("1-6", 8), 0.0833333)
    self.anim8.walk.down = Anim8.newAnimation(self.anim8Grid("1-6", 2), 0.0833333)
    self.anim8.walk.left = Anim8.newAnimation(self.anim8Grid("1-7", 4), 0.0833333)
    self.anim8.walk.right = Anim8.newAnimation(self.anim8Grid("1-7", 6), 0.0833333)
    self.anim8.shadow = Anim8.newAnimation(self.anim8Grid(7, 8))

    self.anim8.idle.up:gotoFrame(2)
    self.anim8.idle.down:gotoFrame(2)
    self.anim8.idle.left:gotoFrame(2)
    self.anim8.idle.right:gotoFrame(2)

    self.offset = love.math.random(-4, 4) * Scale
    if Patients[3] == nil then
        self.x = area:getX() + self.offset
        self.y = area:getY() + 14 * Scale
        Patients[3] = self
    elseif Patients[2] == nil then
        self.x = area:getX() + self.offset
        self.y = area:getY() + self.offset
        Patients[2] = self
    elseif Patients[1] == nil then
        self.x = area:getX()
        self.y = area:getY() - 14 * Scale
        Patients[1] = self
    end

    return self
end

Patient.draw = function (self)
    self:drawSprite()
    self:drawShadow()
    self:drawType()
end

Patient.drawType = function (self)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(self.type, self.x, self.y - self.height * 2 / 4, 0, 0.5 * Scale, 0.5 * Scale, Font:getWidth(self.type) / 2, FontHeight / 2)
end


Patient.drawSprite = function (self)
    if not self.holded then
        love.graphics.setColor(1, 0.6, 0.6, 1)
        self.anim8[self.state][self.facing]:draw(self.spriteSheet, self.x, self.y, self.rotate, Scale, Scale, 32 / 2, 32 / 2)
    end
end

Patient.drawShadow = function (self)
    if not self.holded and self.facing == "up" then
        love.graphics.setColor(1, 1, 1, 0.3)
        self.anim8.shadow:draw(self.spriteSheet, self.x, self.y + 2 * Scale, 0, Scale, Scale, 32 / 2, 32 / 2)
    end
end
--------------------------------------------------------
Patient.update = function (self, dt)
    if self.state == "walk" then
        self.anim8[self.state][self.facing]:update(dt)
    end
end

-------------------------------------------------------
Patient.drawHitbox = function ()
    area = World:newRectangleCollider((Canvas.originX + Canvas.width) - 36 * Scale, Canvas.originY + Canvas.height - 32 * Scale, 32 * Scale, 32 * Scale)
    area:setType("static")
    area:setCollisionClass("patient")
    area:setObject({})
end

return Patient