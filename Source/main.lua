import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/crank"
import "playerTeammate"
import "opponentTeammate"
import "teammate"
import "puck"
import "goal"
import "score"
import "detectionZone"

-- global constants
PLAYER_BODY_TAG = 99
PUCK_TAG = 98
GOAL_TAG = 97
PLAYER_SIDE = 96
OPPONENT_SIDE = 95
PUCK_GROUP = 1
TEAMMATE_GROUP = 2

LONG_TRACK_LENGTH = 130
SHORT_TRACK_LENGTH = 105

local gfx = playdate.graphics
local slib = gfx.sprite
local activePlayerIndex = 1
local players = {} -- player players lol
local opps = {} -- opponent players
-- local PLAYER_ROWS = 3
-- local PLAYER_COLS = 5

-- create players
-- for y = 0, (PLAYER_ROWS-1), 1 do
--     for x = 0, (PLAYER_COLS-1), 1 do
--         table.insert(players, PlayerTeammate((x * 80)+37, (y * 80)+31, x+y))
--     end
-- end

local player_goal = Goal(10, 120, OPPONENT_SIDE)
local opp_goal = Goal(400-10, 120, PLAYER_SIDE)
local player_score = Score(OPPONENT_SIDE)
local opp_score = Score(PLAYER_SIDE)


-- callbacks
local incrementScore =  function (side)
    if side == PLAYER_SIDE then
        player_score.score = player_score.score + 1
        player_score:markDirty()
    else
        opp_score.score = opp_score.score + 1
        opp_score:markDirty()
    end
end

local puck = Puck(200, 140, incrementScore)

-- player
table.insert(players, PlayerTeammate(100, 28, 1, LONG_TRACK_LENGTH))
table.insert(players, PlayerTeammate(400-110, 28 + 57.333, 2, SHORT_TRACK_LENGTH))
table.insert(players, PlayerTeammate(110, 28 + 57.333 + 57.333, 3, SHORT_TRACK_LENGTH))
table.insert(players, PlayerTeammate(300, 200, 4, LONG_TRACK_LENGTH))

-- opponent
table.insert(opps, OpponentTeammate(300, 28, 3, LONG_TRACK_LENGTH))
table.insert(opps, OpponentTeammate(110, 28 + 57.333, 1, SHORT_TRACK_LENGTH))
table.insert(opps, OpponentTeammate(400-110, 28 + 57.333 + 57.333, 4, SHORT_TRACK_LENGTH))
table.insert(opps, OpponentTeammate(100, 200, 2, LONG_TRACK_LENGTH))

players[activePlayerIndex].active = true

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
    puck.velocity.dx = 0
    puck.velocity.dy = 0
    puck:moveTo(players[activePlayerIndex].x, players[activePlayerIndex].y + 25)
end

function playdate.BButtonDown()
    puck:moveTo(math.random(20, 380), math.random(20,220))
    puck.velocity.x = math.random(-25, 25)
    puck.velocity.y = math.random(-25, 25)
end

playdate.display.setRefreshRate(50)
function playdate.update()
    slib.update()
    local ap = players[activePlayerIndex]
    ap.rotation = playdate.getCrankTicks(100)
    gfx.drawLine(ap.x - 10, ap.y + 20, ap.x + 20, ap.y + 20)
    playdate.drawFPS()
end

-- puck:remove()
-- puck = Puck(players[activePlayerIndex].x, players[activePlayerIndex].y + 25)

-- puck:remove()
-- puck = Puck(math.random(20, 380), math.random(20,220))