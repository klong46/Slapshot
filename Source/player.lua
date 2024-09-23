local gfx = playdate.graphics
local slib = gfx.sprite

class('Player').extends(slib)

-- local IMG_START = 1
local IMG_END = 100
local IMG_PREFIX = 'img/player/'

function Player:init(x, y)
    Player.super.init(self)
    self.active = false
    self.imageNum = 0
    self:setImage(self:getImage())
    self:moveTo(x, y)
    self:add()
end

function Player:getNewImgNum(rotation)
    local newImgNum = self.imageNum
    newImgNum = (self.imageNum + rotation) % IMG_END
    return newImgNum
end

function Player:getImage()
    if self.imageNum < 10 then
        return gfx.image.new(IMG_PREFIX..'000'..self.imageNum)
    end
    if self.imageNum < 100 then
        return gfx.image.new(IMG_PREFIX..'00'..self.imageNum)
    end
    return gfx.image.new(IMG_PREFIX..'0'..self.imageNum)
end

function Player:rotate(rotation)
    if rotation > 0 then
        self.imageNum = self:getNewImgNum(rotation)
    elseif rotation < 0 then
        self.imageNum = self:getNewImgNum(rotation)
    end
    self:setImage(self:getImage())
end

function Player:update()
    Player.super.update(self)
    if Ticks ~= 0 and self.active then
        self:rotate(Ticks)
    end
end
