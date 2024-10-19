import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/crank"
import "player"
import "puck"
import "playerBody"

-- global constants
PLAYER_BODY_TAG = 99
PUCK_TAG = 98

-- global variables
Ticks = 0

local gfx = playdate.graphics
local slib = gfx.sprite
local activePlayerIndex = 4
local players = {}

-- create players
for y = 0, 2, 1 do
    for x = 0, 4, 1 do
        table.insert(players, Player((x * 80)+37, (y * 80)+31, x+y))
    end
end
players[activePlayerIndex].active = true

Puck(40, 20)

function playdate.rightButtonDown()
    players[activePlayerIndex].active = false
    activePlayerIndex = (activePlayerIndex % #players) + 1
    players[activePlayerIndex].active = true
end

function playdate.leftButtonDown()
    players[activePlayerIndex].active = false
    if activePlayerIndex == 1 then
        activePlayerIndex = #players
    else
        activePlayerIndex = activePlayerIndex - 1
    end
    players[activePlayerIndex].active = true
end

function playdate.update()
    slib.update()
    Ticks = playdate.getCrankTicks(50)
end