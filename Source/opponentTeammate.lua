local gfx = playdate.graphics

class('OpponentTeammate').extends(Teammate)

function OpponentTeammate:init(x, y, tagNum, trackLength, puckPosition)
    OpponentTeammate.super.init(self, x, y, tagNum, trackLength)
    self.detectionZone = DetectionZone(x, y, 100, 100)
end

function OpponentTeammate:update()
    OpponentTeammate.super.update(self)
    if self.detectionZone.active then
        self:rotate(3)
    end
end

