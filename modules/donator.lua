local Donator = {}
Donator.__index = Donator

local spritePath = "assets/sprites/doctor/"

Donator.new = function (row, state, t)
    local self = setmetatable({}, Donator)

    --init
    self.type = t or TypeList[love.math.random(1, 4)]

    --attr
    self.name = "donator"
    self.row = row
    self.state = state
    self.height = 32 * Scale
    self.width = 16 * Scale

    self.holded = false

    self.x = self.state == 1 and Canvas.originX + self.width + 2 * Scale or self.state == 2 and Canvas.originX + Scale or Canvas.originX - self.width  - Scale
    self.y = self.row == 1 and Canvas.height / 2 - self.height / 3 - 4 * Scale or Canvas.height / 2

    self.color = {love.math.colorFromBytes(0, 255, 0)}

    self.spriteSheet = love.graphics.newImage(spritePath.."1_sheet.png")
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
    self.anim8.shadow = Anim8.newAnimation(self.anim8Grid(7, 8), 1)
    self.timer = love.math.random(3, 9)

    return self
end

Donator.draw = function (self)
    self:drawDebug()
end

Donator.drawDebug = function (self)
    if self.holded then
        return
    end
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    self:drawType()
end

Donator.drawType = function (self)
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

--------------------------------------------------------
Donator.update = function (self, dt)
end

-------------------------------------------------------
Donator.drawArea = function ()
    local area = World:newRectangleCollider(Canvas.originX + 4 * Scale, Canvas.originY + Canvas.height - 32 * Scale, 32 * Scale, 32 * Scale)
    area:setType("static")
    area:setCollisionClass("donator")
end

return Donator