local gfx = playdate.graphics
local slib = gfx.sprite
local geo = playdate.geometry

class('Player').extends(slib)

local IMG_START = 97
local IMG_END = 100
local IMG_PREFIX = 'img/player/'
local ROT_SPEED = 2
local MOVEMENT_SPEED = 3
local TRACK_WIDTH = 4
local TRACK_LENGTH = 150

local function getDegreesOfRotation(imageNum)
    return math.rad((imageNum+3) * 3.6) -- convert from 0-100 imageNum to radians
end

local function convertImageNumToVector(degreesOfRotation)
    return geo.vector2D.new(math.sin(degreesOfRotation), math.cos(degreesOfRotation))
end

local function setMagnitude(rot)
    if rot == 0 then return rot end
    -- negative for force direction to be correct
    return -rot
end

-- TODO: this sucks
local function getImage(imageNum)
    if imageNum < 10 then
        return gfx.image.new(IMG_PREFIX..'000'..imageNum)
    end
    if imageNum < 100 then
        return gfx.image.new(IMG_PREFIX..'00'..imageNum)
    end
    return gfx.image.new(IMG_PREFIX..'0'..imageNum)
end

local function getImageNum(rotation, imageNum)
    rotation = math.floor(rotation*ROT_SPEED)
    return (imageNum + rotation) % IMG_END
end

local function drawTrack(x, y, tagNum)
    local trackImage = gfx.image.new(TRACK_LENGTH, TRACK_WIDTH+1)
    gfx.pushContext(trackImage)
        gfx.setColor(gfx.kColorBlack)
        gfx.setLineWidth(TRACK_WIDTH)
        gfx.setLineCapStyle(gfx.kLineCapStyleRound)
        gfx.drawLine(TRACK_WIDTH, TRACK_WIDTH/2, TRACK_LENGTH-TRACK_WIDTH, TRACK_WIDTH/2)
    gfx.popContext()
    local trackSprite = gfx.sprite.new(trackImage)
    trackSprite:moveTo(x,y)
    trackSprite:add()
    print(trackSprite:getPosition())
    return trackSprite
end

local function trackStart(track)
    return track.x - (TRACK_LENGTH/2)
end

local function trackEnd(track)
    return track.x + (TRACK_LENGTH/2)
end

function Player:init(x, y, tagNum)
    Player.super.init(self)
    self.rotation = 0
    self.active = false
    self.imageNum = IMG_START
    self.rotationVector = convertImageNumToVector(getDegreesOfRotation(self.imageNum))
    self.rotationMagnitude = 0
    self.movement = 0 -- -1 = left, 1 = right
    self.track = drawTrack(x, y, tagNum)
    self:setImage(getImage(self.imageNum))
    self:moveTo(x, y)
    self:setCollideRect(67, 35, 27, 50) -- TODO: no magic
    self:setTag(tagNum)
    self:setZIndex(1)
    self:add()
end

function Player:rotate(rotation)
    self.imageNum = getImageNum(rotation, self.imageNum)
    self:setImage(getImage(self.imageNum))
    local degreesOfRotation = getDegreesOfRotation(self.imageNum)
    self.rotationVector = convertImageNumToVector(degreesOfRotation)
    self.rotationMagnitude = setMagnitude(rotation)
    local rect = self:getCollideRect()
    -- TODO: no magic
    self:setCollideRect(40 + (27 * math.cos(degreesOfRotation)), (35 + (-30 * math.sin(degreesOfRotation))), rect.w, 30 + (20 * math.abs(math.cos(degreesOfRotation))))
end

function Player:update()
    Player.super.update(self)
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
