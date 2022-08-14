local Bed = {}
Bed.__index = Bed

Bed.new = function ()
    local self = setmetatable({}, Bed)
    self.name = "bed"
    self.width = 20 * Scale
    self.height = 34 * Scale
    self.x = nil
    self.y = nil
    self.item = {}
    self.bloodbag = {}

    if Beds[1] == nil then
        self.x, self.y = ScreenWidth / 2 - (54 * Scale) - self.width / 2, 34 * Scale
    elseif Beds[2] == nil then
        self.x, self.y = ScreenWidth / 2 - self.width / 2, 34 * Scale
    else
        self.x, self.y = ScreenWidth / 2 + (54 * Scale) - self.width / 2, 34 * Scale
    end


    self.sprite = {}
    self.sprite.full = Sprite.bed
    self.sprite.bed = love.graphics.newQuad(0, 0, 20, 46, self.sprite.full:getDimensions())
    self.sprite.legs = love.graphics.newQuad(20, 0, 20, 46, self.sprite.full:getDimensions())

    self.collider = World:newRectangleCollider(self.x, self.y, self.width, self.height)
    self.collider:setObject(self)
    self.collider:setType("static")
    self.collider:setCollisionClass("bed")

    table.insert(Beds, self)
    return self
end

---------------------------------------------
Bed.draw = function (self)
    self:drawBed()
    self:drawItem()
    self:drawLegs()
    self:drawBloodBag()
end

Bed.drawBed = function (self)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.sprite.full, self.sprite.bed, self.x, self.y - 6 * Scale, 0, Scale, Scale)
end

Bed.drawItem = function (self)
    if not next(self.item) then
        return
    end
    self.item.x, self.item.y = self.x + self.width / 2, self.y + self.height / 2 - 1 * Scale
    self.item.facing = "down"
    self.item.rotate = 0
    self.item:draw()
end

Bed.drawLegs = function (self)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.sprite.full, self.sprite.legs, self.x, self.y - 6 * Scale, 0, Scale, Scale)
end

Bed.drawBloodBag = function (self)
    if next(self.bloodbag) then
        self.bloodbag.x = self.x + self.width / 2
        self.bloodbag.y = self.y - 22 * Scale

        self.bloodbag:draw()
    end
end

Bed.drawShadow = function (self)
    love.graphics.setColor(0, 0, 0, 0.3)
    love.graphics.rectangle("fill", self.x, self.y + 6 * Scale, self.width, self.height)
end

-------------------------------------------
Bed.update = function (self, dt)
    self:itemUpdate(dt)
end

Bed.itemUpdate = function (self, dt)
    if next(self.item) then
        self.item:update(dt)
    end
end
------------------------------------------

return Bed