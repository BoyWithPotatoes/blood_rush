local Player = {}
Player.__index = Player

local spritePath = "assets/sprites/doctor/"

Player.new = function (id, name, x, y, keyBind)
    local self = setmetatable({}, Player)

    --init
    self.id = id
    self.name = name
    self.keyBind = keyBind

    --attr
    self.height = 32 * Scale
    self.width = 16 * Scale

    self.x = x - self.width / 2
    self.y = y - self.height / 2

    -- state
    self.facing = "down"
    self.interact = false
    self.interItem = {}
    self.speed = Canvas.width / 3
    
    -- animation
    self.timer = love.math.random(4, 10)
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

    self.collider = World:newBSGRectangleCollider(
        self.x,
        self.y,
        self.width + 2 * Scale,
        self.height / 4 + 2 * Scale,
        3 * Scale
    )
    self.collider:setFixedRotation(true)
    self.collider:setCollisionClass("player")
    self.collider:setFriction(0)

    self.sensor = World:newCircleCollider(
        self.x, self.y, 0.5
    )
    self.sensor:setFixedRotation(true)
    self.sensor:setType("dynamic")
    self.sensor:setCollisionClass("plrSensor")

    self.hold = false
    self.holdItem = {}

    return self
end

--------------------------------------------------------------
Player.draw = function (self)
    self:anim8Draw()
end

Player.anim8Draw = function (self)
    local y = self.y - self.height / 5.5
    love.graphics.setColor(1, 1, 1, 1)
    if self.walk then
        self.anim8.walk[self.facing]:draw(self.spriteSheet, self.x, y, 0, Scale, Scale, 32 / 2, 32 / 2)
    else
        self.anim8.idle[self.facing]:draw(self.spriteSheet, self.x, y, 0, Scale, Scale, 32 / 2, 32 / 2)
    end
end

Player.drawShadow = function (self)
    local y = self.y - self.height / 5.5 + 2 * Scale
    love.graphics.setColor(1, 1, 1, 0.3)
    self.anim8.shadow:draw(self.spriteSheet, self.x, y, 0, Scale, Scale, 32 / 2, 32 / 2)
end

local interBtnSize = 8
Player.drawInterButton = function (self)
    if self.interact then
        local x, y = self.x - interBtnSize * Scale / 2, (self.y - interBtnSize * Scale / 2) - 26 * Scale
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("fill", x, y, interBtnSize * Scale, interBtnSize * Scale)
        love.graphics.setColor(1, 1, 1, 1)
        local upperCaseInterButon = string.upper(self.keyBind[5])
        love.graphics.print(
            upperCaseInterButon,
            x + (interBtnSize * Scale) / 2,
            y + (interBtnSize * Scale) / 2,
            0,
            0.4 * Scale, 0.4 * Scale,
            Font:getWidth(upperCaseInterButon) / 2,
            FontHeight / 2
        )
    end
end

Player.drawHold = function (self)
    if not self.hold then
        return
    end
    love.graphics.setColor(self.holdItem.color)
    love.graphics.rectangle("fill", self.x - self.height / 2, self.y - self.height - (2 * Scale), self.height, self.width)
    self:drawType()
end

Player.drawType = function (self)
    love.graphics.setColor(1, 1, 1 ,1)
    love.graphics.print(
        self.holdItem.type,
        self.x,
        self.y - self.height + 6 * Scale,
        0,
        AspetRatio,
        AspetRatio,
        Font:getWidth(self.holdItem.type) / 2,
        FontHeight / 2
    )
end

-------------------------------------------------------------
Player.update = function (self, dt)
    self:control()
    self:updatePosition()
    self:updateSensor()
    self:updateInteract()
    self:anim8Update(dt)
end

Player.control = function (self)
    local velX, velY = 0, 0
    self.walk = false

    if love.keyboard.isDown(self.keyBind[3]) then
        velX = -1
        self.facing = "left"
        self.walk = true
    end
    if love.keyboard.isDown(self.keyBind[4]) then
        velX = 1
        self.facing = "right"
        self.walk = true
    end
    if love.keyboard.isDown(self.keyBind[1]) then
        velY = -1
        self.facing = "up"
        self.walk = true
    end
    if love.keyboard.isDown(self.keyBind[2]) then
        velY = 1
        self.facing = "down"
        self.walk = true
    end
    self.collider:setLinearVelocity(self.speed * velX, self.speed * velY)
    self.sensor:setLinearVelocity(self.speed * velX, self.speed * velY)
end

Player.updatePosition = function (self)
    self.x = self.collider:getX()
    self.y = self.collider:getY()
end

Player.updateSensor = function (self)
    local x, y = self.x, self.y
    if self.facing == "up" then
        y = y - self.height / 5
    elseif self.facing == "down" then
        y = y + self.height / 5
    elseif self.facing == "left" then
        x = x - self.width / 1.5
    elseif self.facing == "right" then
        x = x + self.width / 1.5
    end
    self.sensor:setPosition(x, y)
end

Player.updateInteract = function (self)
    if self.sensor:enter("donator") then
        self.interact = true
    end
end

Player.anim8Update = function (self, dt)
    if self.walk then
        self.anim8.walk[self.facing]:update(dt)
        self.timer = math.floor((dt * 10000) % 10) < 4 and 4 or math.floor((dt * 10000) % 10)
    else
        self.timer = self.timer - dt
        if self.timer <= 0 then
            self.anim8.idle[self.facing]:update(dt)
            if self.timer <= -0.25 then
                self.timer = math.floor((dt * 10000) % 10) < 4 and 4 or math.floor((dt * 10000) % 10)
            end
        else
            self.anim8.idle[self.facing]:gotoFrame(6)
        end
    end
end

---------------------------------------------------------
Player.keypressed = function (self, key)
    if self.interact and key == self.keyBind[5] then
    end
end

return Player