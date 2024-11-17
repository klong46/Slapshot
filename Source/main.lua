import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/crank"
import "player"
import "puck"
import "goal"

-- global constants
PLAYER_BODY_TAG = 99
PUCK_TAG = 98
GOAL_TAG = 97

local gfx = playdate.graphics
local slib = gfx.sprite
local activePlayerIndex = 1
local players = {} -- player players lol
local opps = {} -- opponent players
local PLAYER_ROWS = 3
local PLAYER_COLS = 5

-- create players
-- for y = 0, (PLAYER_ROWS-1), 1 do
--     for x = 0, (PLAYER_COLS-1), 1 do
--         table.insert(players, Player((x * 80)+37, (y * 80)+31, x+y))
--     end
-- end

-- player
table.insert(players, Player(120, 28, 1))
table.insert(players, Player(270, 28 + 57.333, 2))
table.insert(players, Player(120, 28 + 57.333 + 57.333, 3))
table.insert(players, Player(270, 200, 4))
-- local playerGoalie =  Player(400-30, 120, 5)

-- opponent

table.insert(opps, Player(120, 28 + 57.333, 1))
table.insert(opps, Player(120, 200, 1))
table.insert(opps, Player(270, 28, 1))
table.insert(opps, Player(270, 28 + 57.333 + 57.333, 1))
-- local opponentGoalie =  Player(30, 120, 1)

players[activePlayerIndex].active = true

local puck = Puck(10, 200)
local left_goal = Goal(10, 120, "left")
local right_goal = Goal(400-10, 120, "right")

-- button queries
function playdate.rightButtonDown()
    players[activePlayerIndex].movement = 1
end

function playdate.leftButtonDown()
    players[activePlayerIndex].movement = -1
end

function playdate.leftButtonUp()
    if not playdate.buttonIsPressed(playdate.kButtonRight) then
        players[activePlayerIndex].movement = 0
    end
end

function playdate.rightButtonUp()
    if not playdate.buttonIsPressed(playdate.kButtonLeft) then
        players[activePlayerIndex].movement = 0
    end
end

function playdate.upButtonDown()
    players[activePlayerIndex].active = false
    if activePlayerIndex == 1 then
        activePlayerIndex = #players
    else
        activePlayerIndex = activePlayerIndex - 1
    end
    players[activePlayerIndex].active = true
end

function playdate.downButtonDown()
    players[activePlayerIndex].active = false
    activePlayerIndex = (activePlayerIndex % #players) + 1
    players[activePlayerIndex].active = true
end

function playdate.AButtonDown()
    puck:remove()
    puck = Puck(players[activePlayerIndex].x, players[activePlayerIndex].y + 25)
end

function playdate.BButtonDown()
    puck:remove()
    puck = Puck(math.random(20, 380), math.random(20,220))
    puck.velocity.x = math.random(5, 25)
    puck.velocity.y = math.random(5, 25)
end

function playdate.update()
    slib.update()
    local ap = players[activePlayerIndex]
    ap.rotation = playdate.getCrankTicks(50)
    gfx.drawLine(ap.x - 10, ap.y + 20, ap.x + 20, ap.y + 20)
end

-- puck:remove()
-- puck = Puck(players[activePlayerIndex].x, players[activePlayerIndex].y + 25)

-- puck:remove()
-- puck = Puck(math.random(20, 380), math.random(20,220))