local gfx = playdate.graphics
local slib = gfx.sprite

class('DetectionZone').extends(slib)

function DetectionZone:init(x, y, width, height)
    DetectionZone.super.init(self)
    self:setSize(width, height)
    self:moveTo(x, y)
    self:setCollideRect(0, 0, self:getSize())
    self:setCollidesWithGroups(PUCK_GROUP)
    self.collisionResponse = "overlap"
    self.active = false
    self:add()
end

function DetectionZone:update()
    DetectionZone.super.update(self)
    local collisions = self:overlappingSprites()
    self.active = (#collisions > 0)
end

