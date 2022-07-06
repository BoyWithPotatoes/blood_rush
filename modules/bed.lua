local Bed = {}
Bed.__index = Bed

local bedList = {}

local tableFind = function (table, item)
    for i, v in pairs(item) do
        if item == v then
            return i
        else
            return -1
        end
    end
end

Bed.new = function (x, y)
    local self = setmetatable({}, Bed)
    self.offset = 50
    self.width = Player1.width / 2 + 20
    self.height = 180
    self.x = (Canvas.originX + x) - self.width / 2
    self.y = (Canvas.originY + y) - self.height / 2

    self.collider = World:newRectangleCollider(self.x, self.y + self.offset, self.width, self.height - self.offset)
    self.collider:setObject(self)
    self.collider:setType("static")
    table.insert(bedList, self)
    self.collider:setCollisionClass("bed")
    return self
end

Bed.drawTop = function ()
    love.graphics.push()
    for i, v in pairs(bedList) do
        love.graphics.setColor(167 / 255, 199 / 255, 231 / 255)
        love.graphics.rectangle("fill", v.x, v.y, v.width, v.height / 3)
    end
    love.graphics.pop()
end

Bed.drawBottom = function ()
    love.graphics.push()
    for i, v in pairs(bedList) do
        love.graphics.setColor(167 / 255, 199 / 255, 231 / 255)
        love.graphics.rectangle("fill", v.x, v.y + (v.height / 3), v.width, v.height * 2 / 3)
    end
    love.graphics.pop()
end

Bed.update = function (self)
    
end

return Bed