local Bound = {}
Bound.__index = Bound

Bound.new = function (ratio)
    local self = setmetatable({}, Bound)
    self.screenWidth = ScreenWidth
    self.screenHeight = ScreenHeight
    self.width = ScreenHeight * ratio
    self.height = ScreenHeight
    self.originX = (ScreenWidth - self.width) / 2
    self.originY = 0

    -- collisoin
    self.collider = {}
    self:createWall("left", (self.screenWidth - self.width) / 4, self.height / 2, (self.screenWidth - self.width) / 2, self.height)
    self:createWall("right", (self.width + (3 * self.screenWidth)) / 4 , self.height / 2, (self.screenWidth - self.width) / 2, self.height)
    self:createWall("top", self.screenWidth / 2, -128 / 2, self.screenWidth, 128)
    self:createWall("bottom", self.screenWidth / 2,self.screenHeight + (128 / 2), self.screenWidth, 128)

    return self
end

Bound.createWall = function (self, side, posX, posY, width, height)
    self.collider[side] = World:newRectangleCollider(posX - width / 2, posY - height / 2, width, height)
    self.collider[side]:setType("static")
    self.collider[side]:setCollisionClass("bound")
end

Bound.draw = function (self)
    love.graphics.push()
    love.graphics.translate(self.screenWidth / 2, self.screenHeight / 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", -self.width / 2, -self.height / 2, self.width, self.height)
    love.graphics.translate(-self.width / 2, -self.height / 2)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.pop()
end

return Bound