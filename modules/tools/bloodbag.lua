local BloodBag = {}
BloodBag.__index = BloodBag

BloodBag.new = function (t, state)
    local self = setmetatable({}, BloodBag)
    self.name = "bloodbag"

    self.type = t or ""
    self.state = state or 0

    self.x = 500
    self.y = 500
    self.width = 14 * Scale
    self.height = 18 * Scale

    self.sprite = {}
    self.sprite[0] = love.graphics.newQuad(112, 0, 14, 18, Sprite.bloodbag:getDimensions())
    self.sprite[1] = love.graphics.newQuad(98, 0, 14, 18, Sprite.bloodbag:getDimensions())
    self.sprite[2] = love.graphics.newQuad(84, 0, 14, 18, Sprite.bloodbag:getDimensions())
    self.sprite[3] = love.graphics.newQuad(70, 0, 14, 18, Sprite.bloodbag:getDimensions())
    self.sprite[4] = love.graphics.newQuad(56, 0, 14, 18, Sprite.bloodbag:getDimensions())
    self.sprite[5] = love.graphics.newQuad(42, 0, 14, 18, Sprite.bloodbag:getDimensions())
    self.sprite[6] = love.graphics.newQuad(28, 0, 14, 18, Sprite.bloodbag:getDimensions())
    self.sprite[7] = love.graphics.newQuad(14, 0, 14, 18, Sprite.bloodbag:getDimensions())
    self.sprite[8] = love.graphics.newQuad(0, 0, 14, 18, Sprite.bloodbag:getDimensions())

    return self
end

BloodBag.draw = function (self)
    self:drawBag()
    self:drawType()
end

BloodBag.drawBag = function (self)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Sprite.bloodbag, self.sprite[self.state], self.x, self.y, 0, Scale, Scale)
end

BloodBag.drawType = function (self)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(self.type, self.x + self.width / 2, self.y + self.height / 2 - 1 * Scale, 0, 0.5 * Scale, 0.5 * Scale, Font:getWidth(self.type) / 2, FontHeight / 2)
end

BloodBag.update = function (self)
    
end

----------------------------------
BloodBag.drawHitbox = function ()
    local hitbox = World:newRectangleCollider(Canvas.originX + 40 * Scale, Canvas.originY + Canvas.height - 30 * Scale, 20 * Scale, 26 * Scale)
    hitbox:setType("static")
    hitbox:setCollisionClass("bloodbag")
end

return BloodBag