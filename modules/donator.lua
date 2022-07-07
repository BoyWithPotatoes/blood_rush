local Donator = {}
Donator.__index = Donator

local typeList = {"A", "B", "AB", "O"}
Donator.new = function (block, type)
    local self = setmetatable(Donator, {})
    --init
    self.block = 1
    
    --attr
    self.type = type or typeList[love.math.random(1, 4)]
    print(self.type)
    return self
end

Donator.draw = function (self)
    
end

Donator.update = function (self, dt)
    
end

return Donator