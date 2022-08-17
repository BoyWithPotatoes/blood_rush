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
    self.pose = "normal"
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
    self.anim8.idle.normal = {}
    self.anim8.idle.normal.up = Anim8.newAnimation(self.anim8Grid("1-6", 7), 0.0416667)
    self.anim8.idle.normal.down = Anim8.newAnimation(self.anim8Grid("1-6", 1), 0.0416667)
    self.anim8.idle.normal.left = Anim8.newAnimation(self.anim8Grid("1-6", 3), 0.0416667)
    self.anim8.idle.normal.right = Anim8.newAnimation(self.anim8Grid("1-6", 5), 0.0416667)
    self.anim8.walk = {}
    self.anim8.walk.normal = {}
    self.anim8.walk.normal.up = Anim8.newAnimation(self.anim8Grid("1-6", 8), 0.0833333)
    self.anim8.walk.normal.down = Anim8.newAnimation(self.anim8Grid("1-6", 2), 0.0833333)
    self.anim8.walk.normal.left = Anim8.newAnimation(self.anim8Grid("1-7", 4), 0.0833333)
    self.anim8.walk.normal.right = Anim8.newAnimation(self.anim8Grid("1-7", 6), 0.0833333)
    self.anim8.shadow = Anim8.newAnimation(self.anim8Grid(7, 8))

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
        self.anim8.walk[self.pose][self.facing]:draw(self.spriteSheet, self.x, y, 0, Scale, Scale, 32 / 2, 32 / 2)
    else
        self.anim8.idle[self.pose][self.facing]:draw(self.spriteSheet, self.x, y, 0, Scale, Scale, 32 / 2, 32 / 2)
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
        if self.holdItem.name == "bloodbag" then
            self.holdItem.x, self.holdItem.y = self.x - self.holdItem.width / 2, self.y - self.holdItem.height / 2 - 22 * Scale
        else
            self.holdItem.x, self.holdItem.y = self.x, self.y - 20 * Scale
            self.holdItem.facing = "left"
            self.holdItem.rotate = math.pi / 2
        end
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
    self:bloodBagInteract()
    self:boxInteract()
    self:binInteract()
end

Player.patientInteract = function (self)
    if self.hold then
        if self.sensor:enter("patient") then
            if self.holdItem.name == "patient" then
                self.interact = "patient"
            else
                self.interact = ""
            end
        end
    else
        if self.sensor:enter("patient") then
            if Patients[1] ~= nil and not Patients[1].holded then
                self.interact = "patient"
            else
                self.interact = ""
            end
        end
        if self.sensor:stay("patient") then
            if Patients[1] ~= nil and not Patients[1].holded then
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
    if self.hold then
        if self.sensor:enter("donator") then
            if self.holdItem.name == "donator" then
                self.interact = "donator"
            else
                self.interact = ""
            end
        end
    else
        if self.sensor:enter("donator") then
            if Donators[1] ~= nil and not Donators[1].holded then
                self.interact = "donator"
            else
                self.interact = ""
            end
        end
        if self.sensor:stay("donator") then
            if Donators[1] ~= nil and not Donators[1].holded then
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

local checkComp = function (d, p)
    if d == "O" then
        return true
    elseif d == "AB" then
        if p == "AB" then
            return true
        else
            return false
        end
    elseif d == "A" then
        if p == "A" or p == "AB" then
            return true
        else
            return false
        end
    elseif d == "B" then
        if p == "B" or p == "AB" then
            return true
        else
            return false
        end
    end
end

Player.bedInteract = function (self)
    if self.hold then
        if self.sensor:enter("bed") then
            local bed = self.sensor:getEnterCollisionData("bed").collider:getObject()
            if next(bed.item) then
                if self.holdItem.name == "bloodbag" then
                    if next(bed.bloodbag) then
                        self.interact = ""
                    else
                        if self.holdItem.state == 0 then
                            if bed.item.name == "donator" then
                                self.interact = "bed"
                            else
                                self.interact = ""
                            end
                        elseif self.holdItem.state == 8 then
                            if bed.item.name == "patient" and checkComp(self.holdItem.type, bed.item.type) then
                                self.interact = "bed"
                            else
                                self.interact = ""
                            end
                        else
                            self.interact = ""
                        end
                    end
                    
                else
                    self.interact = ""
                end
            else
                if self.holdItem.name == "bloodbag" then
                    self.interact = ""
                else
                    self.interact = "bed"
                end
            end
        end
        if self.sensor:stay("bed") then
            local bed = self.sensor:getEnterCollisionData("bed").collider:getObject()
            if next(bed.item) then
                if self.holdItem.name == "bloodbag" then
                    if next(bed.bloodbag) then
                        self.interact = ""
                    else
                        if self.holdItem.state == 0 then
                            if bed.item.name == "donator" then
                                self.interact = "bed"
                            else
                                self.interact = ""
                            end
                        elseif self.holdItem.state == 8 then
                            if bed.item.name == "patient" and checkComp(self.holdItem.type, bed.item.type) then
                                self.interact = "bed"
                            else
                                self.interact = ""
                            end
                        else
                            self.interact = ""
                        end
                    end
                    
                else
                    self.interact = ""
                end
            else
                if self.holdItem.name == "bloodbag" then
                    self.interact = ""
                else
                    self.interact = "bed"
                end
            end
        end
    else
        if self.sensor:enter("bed") then
            local bed = self.sensor:getEnterCollisionData("bed").collider:getObject()
            if next(bed.bloodbag) then
                if bed.bloodbag.state == 8 then
                    if bed.item.name == "donator" then
                        self.interact = "bed"
                    else
                        self.interact = ""
                    end
                else
                    self.interact = ""
                end
            else
                self.interact = ""
            end
        end
        if self.sensor:stay("bed") then
            local bed = self.sensor:getEnterCollisionData("bed").collider:getObject()
            if next(bed.bloodbag) then
                if bed.bloodbag.state == 8 then
                    if bed.item.name == "donator" then
                        self.interact = "bed"
                    else
                        self.interact = ""
                    end
                else
                    self.interact = ""
                end
            else
                self.interact = ""
            end
        end
    end
    if self.sensor:exit("bed") then
        self.interact = ""
    end
end

Player.bloodBagInteract = function (self)
    if self.hold then
        if self.holdItem.name == "bloodbag" and self.holdItem.state == 0 then
            if  self.sensor:enter("bloodbag") then
                self.interact = "bloodbag"
            end
        end
    else
        if self.sensor:enter("bloodbag") then
            self.interact = "bloodbag"
        end
    end
    if self.sensor:exit("bloodbag") then
        self.interact = ""
    end
end

Player.boxInteract = function (self)
    if self.hold then
        if self.sensor:enter("box") then
            local box = self.sensor:getEnterCollisionData("box").collider:getObject()
            if self.holdItem.name == "bloodbag" and self.holdItem.state == 8 and self.holdItem.type == box.type then
                self.interact = "box"
            else
                self.interact = ""
            end
        end
        if self.sensor:stay("box") then
            local box = self.sensor:getEnterCollisionData("box").collider:getObject()
            if self.holdItem.name == "bloodbag" and self.holdItem.state == 8 and self.holdItem.type == box.type and box.current < box.max then
                self.interact = "box"
            else
                self.interact = ""
            end
        end
    else
        if self.sensor:enter("box") then
            local box = self.sensor:getEnterCollisionData("box").collider:getObject()
            if box.current > 0 then
                self.interact = "box"
            else
                self.interact = ""
            end
        end
        if self.sensor:stay("box") then
            local box = self.sensor:getEnterCollisionData("box").collider:getObject()
            if box.current > 0 then
                self.interact = "box"
            else
                self.interact = ""
            end
        end
    end
    if self.sensor:exit("box") then
        self.interact = ""
    end
end

Player.binInteract = function (self)
    if self.hold then
        if self.sensor:enter("bin") then
            if self.holdItem.name == "bloodbag" then
                self.interact = "bin"
            else
                self.interact = ""
            end
        end
    else
        if self.sensor:enter("bin") then
            self.interact = ""
        end
        if self.sensor:stay("bin") then
            self.interact = ""
        end
    end
    if self.sensor:exit("bin") then
        self.interact = ""
    end
end

Player.anim8Update = function (self, dt)
    if self.hold then
        self.pose = "normal"
    else
        self.pose = "normal"
    end
    if self.walk then
        self.anim8.walk[self.pose][self.facing]:update(dt)
        self.timer = math.floor((dt * 10000) % 10) < 4 and 4 or math.floor((dt * 10000) % 10)
    else
        self.timer = self.timer - dt
        if self.timer <= 0 then
            self.anim8.idle[self.pose][self.facing]:update(dt)
            if self.timer <= -0.25 then
                self.timer = math.floor((dt * 10000) % 10) < 4 and 4 or math.floor((dt * 10000) % 10)
            end
        else
            self.anim8.idle[self.pose][self.facing]:gotoFrame(6)
        end
    end
end

---------------------------------------------------------
Player.keypressed = function (self, key)
    if key == self.keyBind[5] then
        if self.interact ~= "" then
            self:pressDonator()
            self:pressPatient()
            self:pressBed()
            self:pressBloodBag()
            self:pressBox()
            self:pressBin()
        end
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
        if self.hold then
            if self.holdItem.name == "donator" or self.holdItem.name == "patient" then
                bed.item = self.holdItem
                if self.holdItem.name == "donator" then
                    self:updateDonator()
                elseif self.holdItem.name == "patient" then
                    self:updatePatient()
                end
            elseif self.holdItem.name == "bloodbag" then
                bed.bloodbag = self.holdItem
                if bed.item.name == "donator" then
                    self:updateDonatorBloodBag(bed)
                elseif bed.item.name == "patient" then
                    self:updatePatientBloodBag(bed)
                end
            end
            self.hold = false
            self.holdItem = {}
        else
            self.holdItem = bed.bloodbag
            self.hold = true
            bed.bloodbag = {}
            bed.item  = {}
        end
    end
end

Player.updateDonator = function ()
    Donators[1] = nil
    Timer.after(0.72, function ()
        Donators[2].state = "walk"
        Flux.to(Donators[2], 0.3, {y = Donators[2].y - 14 * Scale, x = Donators[2].x}):ease("linear")
        Timer.after(0.31, function ()
            Donators[2].state = "idle"
            Donators[3].state = "walk"
            Flux.to(Donators[3], 0.3, {y = Donators[3].y - 14 * Scale, x = Donators[3].x}):ease("linear")
        end)
        Timer.after(0.6, function ()
            Donators[3].state = "idle"
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
        Patients[2].state = "walk"
        Flux.to(Patients[2], 0.3, {y = Patients[2].y - 14 * Scale, x = Patients[2].x}):ease("linear")
        Timer.after(0.31, function ()
            Patients[2].state = "idle"
            Patients[3].state = "walk"
            Flux.to(Patients[3], 0.3, {y = Patients[3].y - 14 * Scale, x = Patients[3].x}):ease("linear")
        end)
        Timer.after(0.6, function ()
            Patients[3].state = "idle"
            Patients[1] = Patients[2]
            Patients[2] = Patients[3]
            Patients[3] = nil
            local newItem = _Patient.new()
            newItem.y = newItem.y + 14 * Scale
            Flux.to(newItem, 0.3, {y = newItem.y - 14 * Scale}):ease("linear")
        end)
    end)
end

local time = 6
Player.updateDonatorBloodBag = function (_, bed)
    Timer.after(time / 9, function ()
        bed.bloodbag.state = 1
        Timer.after(time / 9, function ()
            bed.bloodbag.state = 2
            Timer.after(time / 9, function ()
                bed.bloodbag.state = 3
                Timer.after(time / 9, function ()
                    bed.bloodbag.state = 4
                    Timer.after(time / 9, function ()
                        bed.bloodbag.state = 5
                        Timer.after(time / 9, function ()
                            bed.bloodbag.state = 6
                            Timer.after(time / 9, function ()
                                bed.bloodbag.state = 7
                                Timer.after(time / 9, function ()
                                    bed.bloodbag.state = 8
                                    bed.bloodbag.type = bed.item.type
                                end)
                            end)
                        end)
                    end)
                end)
            end)
        end)
    end)
end

Player.updatePatientBloodBag = function (_, bed)
    Timer.after(time / 9, function ()
        bed.bloodbag.state = 7
        Timer.after(time / 9, function ()
            bed.bloodbag.state = 6
            Timer.after(time / 9, function ()
                bed.bloodbag.state = 5
                Timer.after(time / 9, function ()
                    bed.bloodbag.state = 4
                    Timer.after(time / 9, function ()
                        bed.bloodbag.state = 3
                        Timer.after(time / 9, function ()
                            bed.bloodbag.state = 2
                            Timer.after(time / 9, function ()
                                bed.bloodbag.state = 1
                                Timer.after(time / 9, function ()
                                    bed.bloodbag.state = 0
                                    Timer.after(time / 9, function ()
                                        bed.bloodbag = {}
                                        bed.item = {}
                                    end)
                                end)
                            end)
                        end)
                    end)
                end)
            end)
        end)
    end)
end

Player.pressBloodBag = function (self)
    if self.interact == "bloodbag" then
        if not self.hold then
            self.hold = true
            self.holdItem = _BloodBag.new()
        else
            if self.holdItem.name == "bloodbag" and self.holdItem.state == 0 then
                self.hold = false
                self.holdItem = {}
            end
        end
    end
end

Player.pressBox = function (self)
    if self.interact == "box" then
        local box = self.sensor:getEnterCollisionData("box").collider:getObject()
        if self.hold then
            box.current = box.current + 1
            self.hold = false
            self.holdItem = true
        else
            box.current = box.current - 1
            self.hold = true
            self.holdItem = _BloodBag.new(box.type, 8)
        end
    end
end

Player.pressBin = function (self)
    if self.interact == "bin" then
        self.hold = false
        self.holdItem = {}
    end
end

return Player