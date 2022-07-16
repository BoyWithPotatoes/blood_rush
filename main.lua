local WindField = require("library.windfield")

local _Player = require("modules.player")
local _Bound = require("modules.bound")
local _Bed = require("modules.bed")
local _Donator = require("modules.donator")

local loadFunc = function (table, func, arg)
    for _, v in pairs(table) do
        v[func](v, arg)
    end
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

World = WindField.newWorld(0, 0)
World:addCollisionClass("bound")
World:addCollisionClass("donatorArea")
World:addCollisionClass("bed")
World:addCollisionClass("donator", {ignores = {"donator", "bound", "donatorArea"}})
World:addCollisionClass("player", {ignores = {"player", "donator"}})
World:setQueryDebugDrawing(true)

-- global variable
ScreenWidth, ScreenHeight = love.graphics.getDimensions()
AspetRatio = ScreenWidth / ScreenHeight
ScaleHeight = ScreenHeight / 32
ScaleWidth = ScreenWidth / 32

Canvas = _Bound.new(5 / 4)

function love.load()
    Player = {
        _Player.new(1, "P1", ScreenWidth / 2, ScreenHeight / 2, {"w", "s", "a", "d", "k"}),
        --PlayerM.new(2, "P1", ScreenWidth / 2, ScreenHeight / 2, {"up", "down", "left", "right", "m"})
    }
    Bed = {
        _Bed.new(Canvas.width * 35 / 100, Canvas.height * 35 / 100),
        _Bed.new(Canvas.width * 65 / 100, Canvas.height * 35 / 100),
        _Bed.new(Canvas.width * 35 / 100, Canvas.height * 70 / 100),
        _Bed.new(Canvas.width * 65 / 100, Canvas.height * 70 / 100)
    }
    Donator = {
        _Donator.new(1, 1),
        _Donator.new(1, 2),
        _Donator.new(2, 1),
        _Donator.new(2, 2)
    }
end

function love.draw()
    Canvas:draw()
    loadFunc(Bed, "drawBottom")
    loadFunc(Player, "draw")
    loadFunc(Bed, "drawTop")
    loadFunc(Donator, "draw")
    loadFunc(Player, "drawInterButton")
    debug()
end

function love.update(dt)
    World:update(dt)
    loadFunc(Player, "update", dt)
    loadFunc(Donator, "update", dt)
end

function love.quit()
    
end

function love.keypressed(key)
    loadFunc(Player, "keyPressed", key)
    if key == "kp0" then
        love.event.quit()
    end
end

-- debugging
function debug ()
    World:draw()
    love.graphics.print(tostring(Player[1].walk)..", "..Player[1].facing, 1, 1, 0, 1.5, 1.5)
    love.graphics.print(Player[1].x, 1, 21, 0, 1.5, 1.5)
    love.graphics.print(Player[1].y, 1, 41, 0, 1.5, 1.5)
    love.graphics.print(tostring(love.timer.getFPS()), 1, ScreenHeight - 25, 0, 1.5, 1.5)
end