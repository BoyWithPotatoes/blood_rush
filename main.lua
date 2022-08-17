-- function
local loadFunc = function (table, func, arg)
    for _, v in pairs(table) do
        v[func](v, arg)
    end
end

local function playerPos ()
    if #Players > 1 then
        if Players[1].y > Players[2].y then
            local middle = Players[1]
            Players[1] = Players[2]
            Players[2] = middle
        end
    end
end

-- state
local menu = {}

local game = {}
function game:enter()
    _Patient.drawHitbox()
    _Donator.drawHitbox()
    _BloodBag.drawHitbox()
    _Bin.drawHitbox()

    Players = {}
    _Player.new(1, ScreenWidth / 2, ScreenHeight * 6 / 10, {"w", "s", "a", "d", "e"})
    _Player.new(2, ScreenWidth / 2, ScreenHeight * 6 / 10, {"up", "down", "left", "right", "p"})

    Beds = {}
    _Bed.new()
    _Bed.new()
    _Bed.new()

    Donators = {}
    _Donator.new()
    _Donator.new()
    _Donator.new()

    Patients = {}
    _Patient.new()
    _Patient.new()
    _Patient.new()

    Boxs = {}
    for _, v in pairs(TypeList) do
        _Box.new(v)
    end
end

function game:draw()
    Canvas:draw()
    loadFunc(Players, "drawShadow")
    loadFunc(Beds, "drawShadow")
    loadFunc(Beds, "draw")
    loadFunc(Players, "draw")
    loadFunc(Donators, "draw")
    loadFunc(Patients, "draw")
    loadFunc(Boxs, "draw")
    loadFunc(Players, "drawInterButton")

    debug()
end

function game:update(dt)
    World:update(dt)
    playerPos()
    loadFunc(Players, "update", dt)
    loadFunc(Beds, "update", dt)
    loadFunc(Donators, "update", dt)
    loadFunc(Patients, "update", dt)
end

function game:keypressed(key)
    loadFunc(Players, "keypressed", key)
    if key == "kp0" then
        love.event.quit()
    end
end

function love.load()
    -- library
    WindField = require("library.windfield")
    Timer = require("library.timer")
    Anim8 = require("library.anim8")
    Flux = require("library.flux")
    GameState = require("library.gamestate")

    --object
    _Bound = require("modules.bound")
    _Player = require("modules.entity.player")
    _Bed = require("modules.entity.bed")
    _Donator = require("modules.entity.donator")
    _Patient = require("modules.entity.patient")
    _BloodBag = require("modules.tools.bloodbag")
    _Bin = require("modules.tools.bin")
    _Box = require("modules.tools.box")

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
    World:addCollisionClass("box")
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
    Sprite = {
        doctor = {
            love.graphics.newImage("assets/sprites/doctor/1_sheet.png")
        },
        bed = love.graphics.newImage("assets/sprites/stuff/bed.png"),
        hanger = love.graphics.newImage("assets/sprites/stuff/hanger.png"),
        bloodbag = love.graphics.newImage("assets/sprites/stuff/bloodbag.png"),
    }

    ------------------------------------------------------------------------------------------------------------

    GameState.registerEvents()
	GameState.switch(game)
end

function love.update(dt)
    Timer.update(dt)
    Flux.update(dt)
end

-- debugging
debug = function ()
    World:draw()
    if Players[1] then
        love.graphics.print(Players[1].x, 1, 21, 0, 1.5, 1.5)
        love.graphics.print(Players[1].y, 1, 41, 0, 1.5, 1.5)
        love.graphics.print(Players[1].interact, 1, 61, 0, 1.5, 1.5)
    end
    if Players[2] then
        love.graphics.print(Players[2].x, 1, 161, 0, 1.5, 1.5)
        love.graphics.print(Players[2].y, 1, 181, 0, 1.5, 1.5)
    end
    love.graphics.print(tostring(love.timer.getFPS()), 1, ScreenHeight - 25, 0, 1.5, 1.5)
end