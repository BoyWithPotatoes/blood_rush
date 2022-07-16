local Donator = {}
Donator.__index = Donator

local typeList = {"A", "B", "AB", "O"}

Donator.new = function (row, q, t)
    local self = setmetatable({}, Donator)
    self.scale = ScaleHeight / 8

    --init
    self.type = t or typeList[love.math.random(1, 4)]

    --attr
    self.name = "donator"
    self.row = row
    self.q = q
    self.height = 32 * self.scale
    self.width = 16 * self.scale

    self.x = self.q == 1 and Canvas.originX + self.width + 2 * self.scale or self.q == 2 and Canvas.originX or Canvas.originX - self.width - 2 * self.scale
    self.y = self.row == 1 and Canvas.height / 2 - self.height - 2 * self.scale or self.row == 2 and Canvas.height / 2 or Canvas.height / 2
    self.state = 0

    --physics
    self.collider = World:newRectangleCollider(self.x, self.y, self.width + 2 * self.scale, self.height + 2 * self.scale)
    self.collider:setFixedRotation(true)
    self.collider:setType("dynamic")
    self.collider:setCollisionClass("donator")
    self.collider:setFriction(0)
    self.collider:setObject(self)

    return self
end

Donator.draw = function (self)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.rectangle("fill", self.x + 1 * self.scale, self.y + 1 * self.scale, self.width, self.height)
    love.graphics.setColor(1, 1, 1 ,1)
    love.graphics.print(
        self.type,
        self.x + self.width / 2 + 1 * self.scale,
        self.y + self.height / 2 + 1 * self.scale,
        0,
        AspetRatio,
        AspetRatio,
        Font:getWidth(self.type) / 2,
        Font:getHeight(self.type) / 2
    )
end

Donator.update = function (self, dt)
    self.x = self.collider:getX() - self.width / 2 - 1 * self.scale
    self.y = self.collider:getY() - self.height / 2 - 1 * self.scale
end

return Donator