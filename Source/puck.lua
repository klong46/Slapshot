local gfx = playdate.graphics
local slib = gfx.sprite
local geo = playdate.geometry

class('Puck').extends(slib)

local puckImg = gfx.image.new('img/small_puck')
local HIT_FORCE = 0.5
local BOUNCE_VELOCITY = 0.9
local ICE_FRICTION = 0.05
local CONTACT_JUMP = 0.16
local magnitude
local vector
local direction

local function hitForce(mag)
    if math.abs(mag) < 2 then
        return mag * HIT_FORCE / 2
    elseif math.abs(mag) > 4 then
        return mag * HIT_FORCE * 1.5
    end
    return mag * HIT_FORCE
end

function Puck:init(x, y, incrementScore)
    Puck.super.init(self)
    self.active = false
    self.velocity = geo.vector2D.new(0,0)
    self.incrementScore = incrementScore
    self:setImage(puckImg)
    self.collisionResponse = "overlap"
    self:moveTo(x, y)
    self:setCollideRect(0, 0, self:getSize())
    self:setGroups(PUCK_GROUP)
    self:setTag(PUCK_TAG)
    self.width, self.height = self:getSize()
    self:add()
end

function Puck:reset()
    self.velocity.dx = 0
    self.velocity.dy = 0
    self:moveTo(200, 140)
end

function Puck:update()
    Puck.super.update(self)

    -- check collisions
    local x, y, collisions = self:moveWithCollisions(self.x + self.velocity.dx ,self.y + self.velocity.dy)
    for i, collision in ipairs(collisions) do
        if collision.other:getTag() == GOAL_TAG then
            if (collision.normal.y == 1 and self.y > 140) or
               (collision.normal.y == -1 and self.y < 140) then
                self.velocity.y = self.velocity.y * -BOUNCE_VELOCITY
            elseif collision.normal.x == 1 and collision.other.side == OPPONENT_SIDE then
                self.incrementScore(OPPONENT_SIDE)
                self:reset()
            elseif collision.normal.x == -1 and collision.other.side == PLAYER_SIDE then
                self.incrementScore(PLAYER_SIDE)
                self:reset()
            end
        elseif self:alphaCollision(collision.other) then
            magnitude = collision.other.rotationMagnitude
            vector = collision.other.rotationVector
            if magnitude ~= 0 then
                direction = magnitude / math.abs(magnitude)
                self:moveBy(vector.dx * direction * self.width * CONTACT_JUMP, vector.dy * direction * self.height * CONTACT_JUMP)
                self.velocity.dx = self.velocity.dx + vector.dx * hitForce(magnitude)
                self.velocity.dy = self.velocity.dy + vector.dy * hitForce(magnitude)
            else
                self.velocity = (self.velocity - (self.velocity:projectedAlong(vector) * 2)) * BOUNCE_VELOCITY
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
    if (math.abs(self.velocity.dx) - ICE_FRICTION) < 0 then
        self.velocity.dx = 0
    end
    if (math.abs(self.velocity.dy) - ICE_FRICTION) < 0 then
        self.velocity.dy = 0
    end
    if self.velocity.dx > 0 then
        self.velocity.dx = self.velocity.dx - ICE_FRICTION
    elseif self.velocity.dx < 0 then
        self.velocity.dx = self.velocity.dx + ICE_FRICTION
    end
    if self.velocity.dy > 0 then
        self.velocity.dy = self.velocity.dy - ICE_FRICTION
    elseif self.velocity.dy < 0 then
        self.velocity.dy = self.velocity.dy + ICE_FRICTION
    end
end