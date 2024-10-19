local gfx = playdate.graphics
local slib = gfx.sprite
local geo = playdate.geometry

class('Puck').extends(slib)

local puckImg = gfx.image.new('img/puck')
local HIT_FORCE = 4
local BOUNCE_VELOCITY = 0.9

local function puckCollisionResponse(self, other)
    if other:getTag() == PLAYER_BODY_TAG then
        return slib.kCollisionTypeBounce
    end
    return slib.kCollisionTypeOverlap
end

function Puck:init(x, y)
    Puck.super.init(self)
    self.active = false
    self.imageNum = 0
    self.velocity = geo.vector2D.new(0,0)
    self:setImage(puckImg)
    self.collisionResponse = puckCollisionResponse
    self:moveTo(x, y)
    self:setCollideRect(0, 0, self:getSize())
    self:setTag(PUCK_TAG)
    self.width, self.height = self:getSize()
    self:add()
end

function Puck:update()
    Puck.super.update(self)

    -- check collisions
    local x, y, collisions = self:moveWithCollisions(self.x + self.velocity.dx ,self.y + self.velocity.dy)
    for i, collision in ipairs(collisions) do
        if collision.other:getTag() == PLAYER_BODY_TAG then
            if collision.normal.x == 1 then
                self.velocity.dx = -math.abs(self.velocity.dx) * BOUNCE_VELOCITY
            elseif collision.normal.x == -1 then
                self.velocity.dx = math.abs(self.velocity.dx) * BOUNCE_VELOCITY
            elseif collision.normal.y == -1 then
                self.velocity.dy = -math.abs(self.velocity.dy) * BOUNCE_VELOCITY
            elseif collision.normal.y == 1 then
                self.velocity.dy = math.abs(self.velocity.dy) * BOUNCE_VELOCITY
            end
        else
            if self:alphaCollision(collision.other) then
                local vector = collision.other.rotationVector
                local magnitude = collision.other.rotationMagnitude
                if magnitude ~= 0 then
                    self.velocity.dx = vector.x * magnitude * HIT_FORCE
                    self.velocity.dy = vector.y * magnitude * HIT_FORCE
                else
                    self.velocity = self.velocity - (self.velocity:projectedAlong(vector) * 2)
                end
            end
        end
    end

    -- bounce off walls
    if self.x > 400-(self.width/2) then
        self.velocity.dx = -math.abs(self.velocity.dx) * BOUNCE_VELOCITY
    elseif self.x < (self.width/2) then
        self.velocity.dx = math.abs(self.velocity.dx) * BOUNCE_VELOCITY
    elseif self.y > 240-(self.height/2) then
        self.velocity.dy = -math.abs(self.velocity.dy) * BOUNCE_VELOCITY
    elseif self.y < (self.height/2) then
        self.velocity.dy = math.abs(self.velocity.dy) * BOUNCE_VELOCITY
    end

    -- friction
    if self.velocity.dx > 0 then
        self.velocity.dx = self.velocity.dx - 0.1
    else
        self.velocity.dx = self.velocity.dx + 0.1
    end
    if self.velocity.dy > 0 then
        self.velocity.dy = self.velocity.dy - 0.1
    else
        self.velocity.dy = self.velocity.dy + 0.1
    end
    if math.abs(self.velocity.dx)<=0.1 then
        self.velocity.dx = 0
    end
    if math.abs(self.velocity.dy)<=0.1 then
        self.velocity.dy = 0
    end
end
