import "teammate"

class('PlayerTeammate').extends(Teammate)

local MOVEMENT_SPEED = 3

function PlayerTeammate:init(x, y, tagNum, trackLength)
    PlayerTeammate.super.init(self, x, y, tagNum, trackLength)
    self.trackLength = trackLength
end

function PlayerTeammate:trackStart()
    return self.track.x - (self.trackLength/2)
end

function PlayerTeammate:trackEnd()
    return self.track.x + (self.trackLength/2)
end

function PlayerTeammate:update()
    PlayerTeammate.super.update(self)
    if self.rotation ~= 0 and self.active then
        -- negative to turn in same direction as crank
        self:rotate(-self.rotation)
    elseif self.rotationMagnitude ~= 0 then
        self.rotationMagnitude = 0
    end
    if self.x > self:trackStart() and self.movement < 0 then
        self:moveBy(self.movement * MOVEMENT_SPEED, 0)
    end
    if self.x < self:trackEnd() and self.movement > 0 then
        self:moveBy(self.movement * MOVEMENT_SPEED, 0)
    end
end
