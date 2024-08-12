Pipe = Class {}

function Pipe:init(orientation, y, x)
    self.image = love.graphics.newImage('pipe.png')
    self.x = x
    self.y = y
    self.orientation = orientation
    self.scored = false
end

function Pipe:update(dt)

end

function Pipe:render()
    print()
    love.graphics.draw(self.image, math.floor(self.x + 0.5),
        math.floor((self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y) + 0.5), 0, 0.8,
        self.orientation == 'top' and -1 or 1)
end
