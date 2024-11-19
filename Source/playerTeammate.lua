import "teammate"

class('PlayerTeammate').extends(Teammate)

local MOVEMENT_SPEED = 3
local TRACK_LENGTH

local function trackStart(track)
    return track.x - (TRACK_LENGTH/2)
end

local function trackEnd(track)
    return track.x + (TRACK_LENGTH/2)
end

function PlayerTeammate:init(x, y, tagNum, trackLength)
    PlayerTeammate.super.init(self, x, y, tagNum, trackLength)
    TRACK_LENGTH = trackLength
end

function PlayerTeammate:update()
    PlayerTeammate.super.update(self)
    if self.rotation ~= 0 and self.active then
        -- negative to turn in same direction as crank
        self:rotate(-self.rotation)
    elseif self.rotationMagnitude ~= 0 then
        self.rotationMagnitude = 0
    end
    if self.x > trackStart(self.track) and self.movement < 0 then
        self:moveBy(self.movement * MOVEMENT_SPEED, 0)
    end
    if self.x < trackEnd(self.track) and self.movement > 0 then
        self:moveBy(self.movement * MOVEMENT_SPEED, 0)
    end
end
