import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/crank"
import "player"

local gfx = playdate.graphics
local slib = gfx.sprite
local activePlayerIndex = 1

Ticks = 0

local players = {
    Player(80, 40),
    Player(250, 110),
    Player(320, 40),
    Player(80, 180),
    Player(150, 150),
    Player(320, 180)
}

players[activePlayerIndex].active = true

function playdate.downButtonDown()
    players[activePlayerIndex].active = false
    activePlayerIndex = (activePlayerIndex % #players) + 1
    players[activePlayerIndex].active = true
end

function playdate.upButtonDown()
    players[activePlayerIndex].active = false
    if activePlayerIndex == 1 then
        activePlayerIndex = 6
    else
        activePlayerIndex = activePlayerIndex - 1
    end
    players[activePlayerIndex].active = true
end

function playdate.update()
    slib.update()
    Ticks = playdate.getCrankTicks(50)
    -- print(Ticks)
end