-- library
WindField = require("library.windfield")
Timer = require("library.timer")
Anim8 = require("library.anim8")

--module
_Bound = require("modules.bound")
_Player = require("modules.player")
_Bed = require("modules.bed")
_Donator = require("modules.donator")
_Patient = require("modules.patient")
_BloodBag = require("modules.tools.bloodbag")
_Bin = require("modules.tools.bin")

-- function
local loadFunc = function (table, func, arg)
    for _, v in pairs(table) do
        v[func](v, arg)
    end
end

TableFind = function (table, item)
    for i, v in pairs(table) do
        if v == item then
            return i
        end
    end
    return -1
end

-- setup
love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setFont(
    love.graphics.newImageFont(
        "assets/font/pixel_font.png",
        " abcdefghijklmnopqrstuvwxyz"..
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ0"..
        "123456789.,!?-+/():;%&`'*#=[]\""
    )
)
Font = love.graphics.getFont()
FontHeight = Font:getHeight()

World = WindField.newWorld(0, 0)
World:addCollisionClass("wall")
World:addCollisionClass("bed")
World:addCollisionClass("donator")
World:addCollisionClass("patient")
World:addCollisionClass("bloodbag")
World:addCollisionClass("bin")
World:addCollisionClass("player", {ignores = {"player"}})
World:addCollisionClass("plrSensor", {ignores = {"All"}})
World:setQueryDebugDrawing(true)

-- global variable
ScreenWidth, ScreenHeight = love.graphics.getDimensions()
AspetRatio = ScreenWidth / ScreenHeight
ScaleHeight = ScreenHeight / 32
ScaleWidth = ScreenWidth / 32
Scale = ScaleHeight / 5

Canvas = _Bound.new(100 / 80)

TypeList = {"A", "B", "AB", "O"}

function love.load()
    _Patient.drawArea()
    _Donator.drawArea()
    _BloodBag.drawBox()
    _Bin.drawBox()
    Players = {
        _Player.new(1, "P1", ScreenWidth / 2, ScreenHeight * 6 / 10, {"w", "s", "a", "d", "e"}),
        _Player.new(2, "P2", ScreenWidth / 2, ScreenHeight * 6 / 10, {"up", "down", "left", "right", "p"})
    }
    Bed = {
        _Bed.new(ScreenWidth / 2 - (54 * Scale), 34 * Scale),
        _Bed.new(ScreenWidth / 2, 34 * Scale),
        _Bed.new(ScreenWidth / 2 + (54 * Scale), 34 * Scale)
    }
end

function love.draw()
    Canvas:draw()
    loadFunc(Players, "drawShadow")
    loadFunc(Bed, "drawShadow")
    loadFunc(Bed, "draw")
    loadFunc(Players, "draw")
    loadFunc(Players, "drawInterButton")
    debug()
end

local function playerPos ()
    if #Players > 1 then
        local middle
        if Players[1].y > Players[2].y then
            middle = Players[1]
            Players[1] = Players[2]
            Players[2] = middle
        end
    end
end

function love.update(dt)
    World:update(dt)
    Timer.update(dt)
    playerPos()
    loadFunc(Players, "update", dt)
end

function love.keypressed(key)
    loadFunc(Players, "keypressed", key)
    if key == "kp0" then
        love.event.quit()
    end
end

-- debugging
debug = function ()
    World:draw()
    if Players[1] then
        love.graphics.print(Players[1].x, 1, 21, 0, 1.5, 1.5)
        love.graphics.print(Players[1].y, 1, 41, 0, 1.5, 1.5)
        love.graphics.print(tostring(Players[1].interItem.name), 1, 81, 0, 1.5, 1.5) 
    end
    if Players[2] then
        love.graphics.print(Players[2].x, 1, 161, 0, 1.5, 1.5)
        love.graphics.print(Players[2].y, 1, 181, 0, 1.5, 1.5)
        love.graphics.print(tostring(Players[2].interItem.name), 1, 221, 0, 1.5, 1.5) 
    end
    love.graphics.print(tostring(love.timer.getFPS()), 1, ScreenHeight - 25, 0, 1.5, 1.5)
end