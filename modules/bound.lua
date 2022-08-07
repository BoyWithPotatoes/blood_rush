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

    self.wall = {}
    self:createWall()
    return self
end

Bound.createBound = function (self, side, posX, posY, width, height)
    self.collider[side] = World:newRectangleCollider(posX - width / 2, posY - height / 2, width, height)
    self.collider[side]:setType("static")
    self.collider[side]:setCollisionClass("bound")
end

Bound.createWall = function (self)
    self.wall.left = World:newRectangleCollider(self.originX, self.originY, 4 * Scale, self.height)
    self.wall.right = World:newRectangleCollider(self.originX + self.width - 4 * Scale, self.originY, 4 * Scale, self.height)
    self.wall.top = World:newRectangleCollider(self.originX, self.originY, self.width, 40 * Scale)
    self.wall.bototm = World:newRectangleCollider(self.originX, self.height - 4 * Scale, self.width, 4 * Scale)
    self.wall.donator = World:newRectangleCollider(self.originX + 36 * Scale, self.originY + self.height - 32 * Scale, 4 * Scale, 32 * Scale)
    self.wall.patient = World:newRectangleCollider(self.originX + self.width - 40 * Scale, self.originY + self.height - 32 * Scale, 4 * Scale, 32 * Scale)

    for _, v in pairs(self.wall) do
        v:setType("static")
        v:setCollisionClass("wall")
    end
end

-----------------------------------------------------
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