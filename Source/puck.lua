local gfx = playdate.graphics
local slib = gfx.sprite
local geo = playdate.geometry

class('Puck').extends(slib)

local puckImg = gfx.image.new('img/small_puck')
local HIT_FORCE = 2
local BOUNCE_VELOCITY = 0.9
local ICE_FRICTION = 0.05
local COLLISION_DELAY_FRAMES = 2
local CONTACT_JUMP = 0.25

function Puck:init(x, y)
    Puck.super.init(self)
    self.active = false
    self.velocity = geo.vector2D.new(0,0)
    -- checks if collisions can be detected
    self.collisionDelay = 0
    self:setImage(puckImg)
    self.collisionResponse = "overlap"
    self:moveTo(x, y)
    self:setCollideRect(0, 0, self:getSize())
    self:setTag(PUCK_TAG)
    self.width, self.height = self:getSize()
    self:add()
end

function Puck:update()
    Puck.super.update(self)

    -- countdown until collision are detected again
    if self.collisionDelay > 0 then
        self.collisionDelay = self.collisionDelay - 1
    end

    -- check collisions
    local x, y, collisions = self:moveWithCollisions(self.x + self.velocity.dx ,self.y + self.velocity.dy)
    for i, collision in ipairs(collisions) do
        if self:alphaCollision(collision.other) then
            local magnitude = collision.other.rotationMagnitude
            local vector = collision.other.rotationVector
            if magnitude ~= 0 then
                local direction = magnitude / math.abs(magnitude)
                self:moveBy(vector.dx * direction * self.width * CONTACT_JUMP, vector.dy * direction * self.height * CONTACT_JUMP)
                if self.collisionDelay == 0 then
                    self.velocity.dx = vector.dx * magnitude * HIT_FORCE
                    self.velocity.dy = vector.dy * magnitude * HIT_FORCE
                    -- reset delay after collision
                    self.collisionDelay = COLLISION_DELAY_FRAMES
                end
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