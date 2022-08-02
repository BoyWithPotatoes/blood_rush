local WindField = require("library.windfield")

local _Player = require("modules.player")
local _Bound = require("modules.bound")
local _Bed = require("modules.bed")
local _Donator = require("modules.donator")
local _Patient = require("modules.patient")

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

Timer = require("library.timer")

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
World:addCollisionClass("bound")
World:addCollisionClass("bed")
World:addCollisionClass("donator", {ignores = {"donator"}})
World:addCollisionClass("patient", {ignores = {"patient", "donator"}})
World:addCollisionClass("plrSensor", {ignores = {"All"}})
World:addCollisionClass("player", {ignores = {"player", "plrSensor"}})
World:setQueryDebugDrawing(true)

-- global variable
ScreenWidth, ScreenHeight = love.graphics.getDimensions()
AspetRatio = ScreenWidth / ScreenHeight
ScaleHeight = ScreenHeight / 32
ScaleWidth = ScreenWidth / 32

Canvas = _Bound.new(5 / 4)

TypeList = {"A", "B", "AB", "O"}

function love.load()
    Player = {
        _Player.new(1, "P1", ScreenWidth / 2, ScreenHeight / 2, {"w", "s", "a", "d", "e"}),
        --_Player.new(2, "P2", ScreenWidth / 2, ScreenHeight / 2, {"up", "down", "left", "right", "m"})
    }
    Bed = {
        _Bed.new(Canvas.width * 35 / 100, Canvas.height * 45 / 100),
        _Bed.new(Canvas.width * 65 / 100, Canvas.height * 45 / 100),
        _Bed.new(Canvas.width * 35 / 100, Canvas.height * 70 / 100),
        _Bed.new(Canvas.width * 65 / 100, Canvas.height * 70 / 100)
    }
    Donator = {
        _Donator.new(1, 1),
        _Donator.new(1, 2),
        _Donator.new(2, 1),
        _Donator.new(2, 2),
        _Donator.new(1, 0)
    }
    _Donator.drawArea()
    Patient = {
        _Patient.new(1, 1),
        _Patient.new(1, 2),
        _Patient.new(2, 1),
        _Patient.new(2, 2),
        _Patient.new(2, 0),
    }
    _Patient.drawArea()
end

function love.draw()
    Canvas:draw()
    loadFunc(Player, "drawShadow")
    loadFunc(Bed, "drawBottom")
    loadFunc(Donator, "draw")
    loadFunc(Patient, "draw")
    loadFunc(Player, "draw")
    loadFunc(Bed, "drawTop")
    loadFunc(Player, "drawHold")
    loadFunc(Player, "drawInterButton")
    debug()
end

function love.update(dt)
    World:update(dt)
    Timer.update(dt)
    loadFunc(Player, "update", dt)
    loadFunc(Patient, "update", dt)
end

function love.keypressed(key)
    loadFunc(Player, "keypressed", key)
    if key == "kp0" then
        love.event.quit()
    end
end

-- debugging
function debug ()
    World:draw()
    if Player[1] then
        love.graphics.print(Player[1].x, 1, 21, 0, 1.5, 1.5)
        love.graphics.print(Player[1].y, 1, 41, 0, 1.5, 1.5)
        love.graphics.print(tostring(Player[1].holdItem.name), 1, 81, 0, 1.5, 1.5) 
    end
    love.graphics.print(tostring(love.timer.getFPS()), 1, ScreenHeight - 25, 0, 1.5, 1.5)
end