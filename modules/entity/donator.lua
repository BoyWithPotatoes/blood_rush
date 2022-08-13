local Donator = {}
Donator.__index = Donator

local area

Donator.new = function (t)
    local self = setmetatable({}, Donator)

    --init
    self.type = t or TypeList[love.math.random(1, 4)]
    --attr
    self.name = "donator"
    self.width = 16 * Scale
    self.height = 30 * Scale
    self.x = nil
    self.y = nil
    self.rotate = 0
    self.facing = "up"
    self.holded = false
    self.walk = false

    self.spriteSheet = Sprite.doctor[1]
    self.anim8Grid = Anim8.newGrid(32, 32, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.anim8 = {}
    self.anim8.idle = {}
    self.anim8.idle.up = Anim8.newAnimation(self.anim8Grid("1-6", 7), 0.0416667)
    self.anim8.idle.down = Anim8.newAnimation(self.anim8Grid("1-6", 1), 0.0416667)
    self.anim8.idle.left = Anim8.newAnimation(self.anim8Grid("1-6", 3), 0.0416667)
    self.anim8.idle.right = Anim8.newAnimation(self.anim8Grid("1-6", 5), 0.0416667)

    self.anim8.idle.up:gotoFrame(6)
    self.anim8.idle.down:gotoFrame(6)
    self.anim8.idle.left:gotoFrame(6)
    self.anim8.idle.right:gotoFrame(6)

    self.offset = love.math.random(-4, 4) * Scale
    if Donators[3] == nil then
        self.x = area:getX() + self.offset
        self.y = area:getY() + 14 * Scale
        Donators[3] = self
    elseif Donators[2] == nil then
        self.x = area:getX() + self.offset
        self.y = area:getY() + self.offset
        Donators[2] = self
    elseif Donators[1] == nil then
        self.x = area:getX()
        self.y = area:getY() - 14 * Scale
        Donators[1] = self
    end

    return self
end

Donator.draw = function (self)
    self:drawSprite()
end

Donator.drawSprite = function (self)
    if self.holded then return end
    love.graphics.setColor(1, 1, 1, 1)
    self.anim8.idle[self.facing]:draw(self.spriteSheet, self.x, self.y, self.rotate, Scale, Scale, 32 / 2, 32 / 2)
end
--------------------------------------------------------
Donator.update = function (self, dt)
    --self.anim8.idle[self.facing]:update(dt)
end

-------------------------------------------------------
Donator.drawHitbox = function ()
    area = World:newRectangleCollider(Canvas.originX + 4 * Scale, Canvas.originY + Canvas.height - 32 * Scale, 32 * Scale, 32 * Scale)
    area:setType("static")
    area:setCollisionClass("donator")
    area:setObject({})
end

return Donator