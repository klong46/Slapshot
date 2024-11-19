local gfx = playdate.graphics
local slib = gfx.sprite

class('Score').extends(slib)

local font = gfx.font.new("fonts/font-rains-2x")
local SIZE = {WIDTH = 15, HEIGHT = 15}
local LEFT_POSITION = {X = 20, Y = 20}
local RIGHT_POSITION = {X = 400-20, Y = 20}

function Score:init(side)
    Score.super.init(self)
    self:setSize(SIZE.WIDTH, SIZE.HEIGHT)
    self:setCollideRect(0, 0, self:getSize())
    self.score = 0
    if side == OPPONENT_SIDE then
        self:moveTo(LEFT_POSITION.X, LEFT_POSITION.Y)
    else
        self:moveTo(RIGHT_POSITION.X, RIGHT_POSITION.Y)
    end
    self:add()
end

function Score:draw()
    gfx.setFont(font, "bold")
    gfx.drawText("*"..self.score.."*", 0, 0)
end