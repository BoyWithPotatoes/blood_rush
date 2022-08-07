local Bed = {}
Bed.__index = Bed

Bed.new = function (x, y)
    local self = setmetatable({}, Bed)
    self.name = "bed"
    self.width = 20 * Scale
    self.height = 32 * Scale
    self.x = x - self.width / 2
    self.y = y

    self.occ = false
    self.item = {}

    self.sprite = love.graphics.newImage("assets/sprites/stuff/bed.png")

    self.collider = World:newRectangleCollider(self.x, self.y, self.width, self.height)
    self.collider:setObject(self)
    self.collider:setType("static")
    self.collider:setCollisionClass("bed")
    return self
end

---------------------------------------------
Bed.draw = function (self)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.sprite, self.x, self.y - 6 * Scale, 0, Scale, Scale)
end

Bed.drawShadow = function (self)
    love.graphics.setColor(0, 0, 0, 0.3)
    love.graphics.rectangle("fill", self.x, self.y + 8 * Scale, self.width, self.height)
end

-------------------------------------------
Bed.update = function (self, dt)

end

return Bed