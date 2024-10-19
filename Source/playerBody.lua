local gfx = playdate.graphics
local slib = gfx.sprite

class('PlayerBody').extends(slib)

function PlayerBody:init(x, y)
    PlayerBody.super.init(self)
    self:moveTo(x, y)
    self:setCollideRect(-2, -12, 13, 25)
    self:setTag(PLAYER_BODY_TAG)
    self:add()
end
