import "teammate"

class('PlayerTeammate').extends(Teammate)

local MOVEMENT_SPEED = 3

function PlayerTeammate:init(x, y, tagNum, trackLength)
    PlayerTeammate.super.init(self, x, y, tagNum, trackLength, MOVEMENT_SPEED)
end

function PlayerTeammate:update()
    PlayerTeammate.super.update(self)
    if self.rotation ~= 0 and self.active then
        -- negative to turn in same direction as crank
        self:rotate(-self.rotation)
    elseif self.rotationMagnitude ~= 0 then
        self.rotationMagnitude = 0
    end
end
