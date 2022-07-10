local WindField = require("library.windfield")

local Player = require("modules.player")
local CanvasModule = require("modules.canvas")
local Bed = require("modules.bed")
local Donator = require("modules.donator")

function love.load()
    -- setup
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.physics.setMeter(32)
    World = WindField.newWorld(0, 0)
    World:addCollisionClass("bound")
    World:addCollisionClass("bed")
    World:addCollisionClass("donator")
    World:addCollisionClass("player", {ignores = {"player", "donator"}})
    World:setQueryDebugDrawing(true)
    -- global variable
    BackgroundLayer = love.graphics.newCanvas()
    PlayerLayer = love.graphics.newCanvas()
    ScreenWidth, ScreenHeight = love.graphics.getDimensions()
    ScaleHeight = ScreenHeight / 32
    ScaleWidth = ScreenWidth / 32
    -- load stuff 
    Canvas = CanvasModule.new(5 / 4)
    Player1 = Player.new(1, "P1", ScreenWidth / 2, ScreenHeight / 2, {"w", "s", "a", "d", "return"})
    Bed1 = Bed.new(Canvas.width / 3, 300)
    Bed2 = Bed.new(Canvas.width * 2 / 3, 300)
    Bed3 = Bed.new(Canvas.width / 3, 700)
    Bed4 = Bed.new(Canvas.width * 2 / 3, 700)
    Donator1 = Donator.new(1)
   -- Player2 = Player.new(1, "P2", ScreenWidth / 2, ScreenHeight / 2, {"up", "down", "left", "right", "kp8"})
end

function love.draw()
    Canvas:draw()
    Bed.drawBottom()
    Player1:draw()
    Bed.drawTop()
    --Player2:draw()
    debug()
end

function love.update(dt)
    World:update(dt)
    Canvas:update(dt)
    Player1:update(dt)
    --Player2:update(dt)
end

function love.quit()
    
end

function love.keypressed(key)
    Player1:keyPressed(key)
    if key == "kp0" then
        love.event.quit()
    end
end

-- debugging
function debug ()
    World:draw()
    love.graphics.print(tostring(Player1.walk)..", "..Player1.facing, 1, 1, 0, 1.5, 1.5)
    love.graphics.print(Player1.x, 1, 21, 0, 1.5, 1.5)
    love.graphics.print(Player1.y, 1, 41, 0, 1.5, 1.5)
    love.graphics.print(love.timer.getFPS(), 1, ScreenHeight - 25, 0, 1.5, 1.5)
end