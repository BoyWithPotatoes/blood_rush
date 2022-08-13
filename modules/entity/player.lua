local Player = {}
Player.__index = Player

Player.new = function (id, x, y, keyBind)
    local self = setmetatable({}, Player)

    --init
    self.id = id
    self.name = "player"
    self.keyBind = keyBind

    --attr
    self.height = 32 * Scale
    self.width = 16 * Scale

    self.x = x - self.width / 2
    self.y = y - self.height / 2

    -- state
    self.facing = "down"
    self.interact = ""
    self.speed = Canvas.width / 3
    self.walk = false
    self.hold = false
    self.holdItem = {}
    
    -- animation
    self.timer = love.math.random(4, 10)
    self.spriteSheet = Sprite.doctor[1]
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

    table.insert(Players, self)
    return self
end

--------------------------------------------------------------
Player.draw = function (self)
    self:anim8Draw()
    self:drawItem()
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
    if self.interact ~= "" then
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

Player.drawItem = function (self)
    if self.hold then
        self.holdItem.x, self.holdItem.y = self.x, self.y - 24 * Scale
        self.holdItem.facing = "left"
        self.holdItem.rotate = math.pi / 2
        self.holdItem:draw()
    end
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
    self:donatorInteract()
    self:patientInteract()
    self:bedInteract()
end

Player.patientInteract = function (self)
    if self.hold and self.holdItem.name == "patient" then
        if self.sensor:enter("patient") then
            self.interact = "patient"
        end
    else
        if self.sensor:enter("patient") then
            self.interact = "patient"
        end
        if self.sensor:stay("patient") then
            if Patients[1] then
                self.interact = "patient"
            else
                self.interact = ""
            end
        end
    end
    if self.sensor:exit("patient") then
        self.interact = ""
     end
end

Player.donatorInteract = function (self)
    if self.hold and self.holdItem.name == "donator" then
        if self.sensor:enter("donator") then
            self.interact = "donator"
        end
    else
        if self.sensor:enter("donator") then
            self.interact = "donator"
        end
        if self.sensor:stay("donator") then
            if Donators[1] ~= nil then
                self.interact = "donator"
            else
                self.interact = ""
            end
        end
    end
    if self.sensor:exit("donator") then
        self.interact = ""
    end
end

Player.bedInteract = function (self)
    if self.hold then
        if self.sensor:enter("bed") then
            local bed = self.sensor:getEnterCollisionData("bed").collider:getObject()
            if next(bed.item) then
                self.interact = ""
            else
                self.interact = "bed"
            end
        end
        if self.sensor:stay("bed") then
            local bed = self.sensor:getEnterCollisionData("bed").collider:getObject()
            if next(bed.item) then
                self.interact = ""
            else
                self.interact = "bed"
            end
        end
    else
        if self.sensor:enter("bed") then
            self.interact = ""
        end
        if self.sensor:stay("bed") then
            self.interact = ""
        end
    end
    if self.sensor:exit("bed") then
        self.interact = ""
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
    if key == self.keyBind[5] then
        if self.interact == "" then
            return
        end
        self:pressDonator()
        self:pressPatient()
        self:pressBed()
    end
end

Player.pressDonator = function (self)
    if self.interact == "donator" then
        local item = Donators[1]
        if item ~= nil then
            if not self.hold then
                self.hold = true
                self.holdItem = _Donator.new(item.type)
                item.holded = true
            else
                self.hold = false
                self.holdItem  = {}
                item.holded = false
            end
        end
    end
end

Player.pressPatient = function (self)
    if self.interact == "patient" then
        local item = Patients[1]
        if item ~= nil then
            if not self.hold then
                self.hold = true
                self.holdItem = _Patient.new(item.type)
                item.holded = true
            else
                self.hold = false
                self.holdItem  = {}
                item.holded = false
            end
        end
    end
end

Player.pressBed = function (self)
    if self.interact == "bed" then
        local bed = self.sensor:getEnterCollisionData("bed").collider:getObject()
        bed.item = self.holdItem
        self.hold = false
        if self.holdItem.name == "donator" then
            self:updateDonator()
        elseif self.holdItem.name == "patient" then
            self:updatePatient()
        end
        
        self.holdItem = {}
    end
end

Player.updateDonator = function ()
    Donators[1] = nil
    Timer.after(0.72, function ()
        Flux.to(Donators[2], 0.3, {y = Donators[2].y - 14 * Scale, x = Donators[2].x}):ease("linear")
        Timer.after(0.34, function ()
            Flux.to(Donators[3], 0.3, {y = Donators[3].y - 14 * Scale, x = Donators[3].x}):ease("linear")
        end)
        Timer.after(0.8, function ()
            Donators[1] = Donators[2]
            Donators[2] = Donators[3]
            Donators[3] = nil
            local newItem = _Donator.new()
            newItem.y = newItem.y + 14 * Scale
            Flux.to(newItem, 0.3, {y = newItem.y - 14 * Scale}):ease("linear")
        end)
    end)
end

Player.updatePatient = function ()
    Patients[1] = nil
    Timer.after(0.72, function ()
        Flux.to(Patients[2], 0.3, {y = Patients[2].y - 14 * Scale, x = Patients[2].x}):ease("linear")
        Timer.after(0.34, function ()
            Flux.to(Patients[3], 0.3, {y = Patients[3].y - 14 * Scale, x = Patients[3].x}):ease("linear")
        end)
        Timer.after(0.8, function ()
            Patients[1] = Patients[2]
            Patients[2] = Patients[3]
            Patients[3] = nil
            local newItem = _Patient.new()
            newItem.y = newItem.y + 14 * Scale
            Flux.to(newItem, 0.3, {y = newItem.y - 14 * Scale}):ease("linear")
        end)
    end)
end

return Player