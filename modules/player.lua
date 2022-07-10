local anim8 = require("library.anim8")

local Player = {}
Player.__index = Player

local spritePath = "assets/sprites/doctor/"

Player.new = function (id, name, x, y, control)
    local self = setmetatable({}, Player)
    self.scale = ScaleHeight / 7

    --init
    self.id = id
    self.name = name
    self.x = x
    self.y = y
    self.control = control

    --attr
    self.height = 32 * self.scale
    self.width = 32 * self.scale
    self.lastPosX = self.x
    self.lastPosY = self.y

    -- state
    self.facing = "down"
    self.interact = ""
    self.walk = false
    self.hold = false
    
    -- animation
    self.timer = love.math.random(4, 10)
    self.spriteSheet = love.graphics.newImage(spritePath..id.."_sheet.png")
    self.anim8Grid = anim8.newGrid(32, 32, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.anim8 = {}
    self.anim8.idle = {}
    self.anim8.idle.up = anim8.newAnimation(self.anim8Grid("1-6", 7), 0.0416667)
    self.anim8.idle.down = anim8.newAnimation(self.anim8Grid("1-6", 1), 0.0416667)
    self.anim8.idle.left = anim8.newAnimation(self.anim8Grid("1-6", 3), 0.0416667)
    self.anim8.idle.right = anim8.newAnimation(self.anim8Grid("1-6", 5), 0.0416667)
    self.anim8.walk = {}
    self.anim8.walk.up = anim8.newAnimation(self.anim8Grid("1-6", 8), 0.0833333)
    self.anim8.walk.down = anim8.newAnimation(self.anim8Grid("1-6", 2), 0.0833333)
    self.anim8.walk.left = anim8.newAnimation(self.anim8Grid("1-7", 4), 0.0833333)
    self.anim8.walk.right = anim8.newAnimation(self.anim8Grid("1-7", 6), 0.0833333)

    -- physics
    self.speed = 300
    self.velocity = {}
    self.velocity.x = 0
    self.velocity.y = 0

    self.colliderSizeOffset = 1 * self.scale
    self.colliderHeightOffset = 5 * self.scale
    self.collider = World:newBSGRectangleCollider(
        self.x - self.width / 4 - self.colliderSizeOffset,
        self.y - self.height / 4 - self.colliderSizeOffset + self.colliderHeightOffset,
        self.width / 2 + self.colliderSizeOffset * 2,
        self.height / 2 + self.colliderSizeOffset * 2 - self.colliderHeightOffset,
        (self.height / 2 + self.colliderSizeOffset * 2 - self.colliderHeightOffset) / 3
    )
    self.collider:setFixedRotation(true)
    self.collider:setCollisionClass("player")
    self.collider:setFriction(0)

    return self
end

Player.draw = function (self)
    love.graphics.push()
    self:anim8Draw()
    love.graphics.pop()
end

Player.anim8Draw = function (self)
    local y = (self.y - self.height / 4) - self.colliderHeightOffset / 2
    love.graphics.setColor(1, 1, 1, 1)
    if self.walk then
        self.anim8.walk[self.facing]:draw(self.spriteSheet, self.x, y, 0, self.scale, self.scale, 32 / 2, 32 / 2)
    else
        self.anim8.idle[self.facing]:draw(self.spriteSheet, self.x, y, 0, self.scale, self.scale, 32 / 2, 32 / 2)
    end
end

Player.update = function (self, dt)
    self:keyControl(dt)
    self:showEventKey(dt)
    self:anim8Update(dt)
end

Player.keyControl = function (self, dt)
    local velX, velY = 0, 0
    self.walk = false

    if love.keyboard.isDown(self.control[1]) then
        velY = -1
        self.facing = "up"
        self.walk = true
    end
    if love.keyboard.isDown(self.control[2]) then
        velY = 1
        self.facing = "down"
        self.walk = true
    end
    if love.keyboard.isDown(self.control[3]) then
        velX = -1
        self.facing = "left"
        self.walk = true
    end
    if love.keyboard.isDown(self.control[4]) then
        velX = 1
        self.facing = "right"
        self.walk = true
    end
    self.collider:setLinearVelocity(self.speed * velX, self.speed * velY)
    self:updateCollider(self.collider)
end

Player.showEventKey = function (self, dt)
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

Player.updateCollider = function (self, collider)
    self.x = collider:getX()
    self.y = collider:getY()
end

Player.keyPressed = function (self, key)
    if key == self.control[5] then
    end
end

return Player