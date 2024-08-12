Bird = Class {}

local g = 10

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT / 2
    self.dy = 0
    self.r = 0
end

local counter = 0;
local rotation_speed = 5 -- Controls how quickly the rotation changes

function Bird:update(dt)
    self.dy = self.dy + g * dt
    if love.keyboard.wasPressed('space') then
        self.dy = -2.5
        counter = 1
    end
    if counter > 0 then
        counter = counter - dt
    end

    if counter > 0.85 then
        self.r = math.max(self.r - rotation_speed * dt, -0.2)
    elseif counter > 0.55 then
        if self.r < 0 then
            self.r = math.min(self.r + rotation_speed * dt, 0)
        else
            self.r = math.max(self.r - rotation_speed * dt, 0)
        end
    else
        self.r = math.min(self.r + rotation_speed * dt, 0.2)
    end
    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y, self.r)
end
