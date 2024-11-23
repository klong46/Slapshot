local geo = playdate.geometry

class('OpponentTeammate').extends(Teammate)

local MOVEMENT_SPEED = 2


function OpponentTeammate:init(x, y, tagNum, trackLength)
    OpponentTeammate.super.init(self, x, y, tagNum, trackLength, MOVEMENT_SPEED)
    self.distanceToPuck = 0
    self.isClosest = false
end

function OpponentTeammate:update()
    OpponentTeammate.super.update(self)
    self.distanceToPuck = geo.distanceToPoint(self.x, self.y, PuckPos.x, PuckPos.y)
    if self.isClosest then
        if PuckPos.x + 1 < self.x then
            self.movement = -1
        elseif PuckPos.x - 1 > self.x then
            self.movement = 1
        else
            self.movement = 0
        end

        if self.distanceToPuck < 50 then
            if PuckPos.y < self.y then
                self:rotate(-4)
            else
                self:rotate(4)
            end
        end
    else
        self.movement = 0
    end
end

