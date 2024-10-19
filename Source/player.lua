local gfx = playdate.graphics
local slib = gfx.sprite
local geo = playdate.geometry

class('Player').extends(slib)

local IMG_START = 97
local IMG_END = 100
local IMG_PREFIX = 'img/player/'
local ROT_SPEED = 2

local function getDegreesOfRotation(imgNum)
    return math.rad((imgNum+3) * 3.6) -- convert from 0-100 imgNum to radians
end

local function convertImageNumToVector(degreesOfRotation)
    return geo.vector2D.new(math.sin(degreesOfRotation), math.cos(degreesOfRotation))
end

function Player:init(x, y, tagNum)
    Player.super.init(self)
    self.active = false
    self.imageNum = IMG_START
    self.rotationVector = convertImageNumToVector(getDegreesOfRotation(self.imageNum))
    self.rotationMagnitude = nil
    self:setImage(self:getImage())
    self:moveTo(x, y)
    self:setCollideRect(67, 35, 27, 50)
    self:setTag(tagNum)
    -- self.body = PlayerBody(x, y)
    self:setZIndex(1)
    self:add()
end

function Player:setNewImg(rotation)
    rotation = math.floor(rotation*ROT_SPEED)
    self.imageNum = (self.imageNum + rotation) % IMG_END
    self:setImage(self:getImage())
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
    self:setNewImg(rotation)
    local degreesOfRotation = getDegreesOfRotation(self.imageNum)
    self.rotationVector = convertImageNumToVector(degreesOfRotation)
    self.rotationMagnitude = rotation*-1
    local rect = self:getCollideRect()
    print(math.cos(degreesOfRotation))
    self:setCollideRect(40 + (27 * math.cos(degreesOfRotation)), (35 + (-30 * math.sin(degreesOfRotation))), rect.w, 30 + (20 * math.abs(math.cos(degreesOfRotation))))
end

function Player:update()
    Player.super.update(self)
    if Ticks ~= 0 and self.active then
        self:rotate(Ticks)
    elseif self.rotationMagnitude ~= 0 then
        self.rotationMagnitude = 0
    end
end
