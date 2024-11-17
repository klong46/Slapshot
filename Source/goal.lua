local gfx = playdate.graphics
local slib = gfx.sprite

class('Goal').extends(slib)

function Goal:init(x, y, side)
    Goal.super.init(self)
    local goalImg = gfx.image.new('img/left_goal')
    if side == "right" then
        goalImg = gfx.image.new('img/right_goal')
    end
    self:setImage(goalImg)
    self.collisionResponse = "overlap"
    self:moveTo(x, y)
    self:setCollideRect(0, 0, self:getSize())
    self:setTag(GOAL_TAG)
    self:add()
end
