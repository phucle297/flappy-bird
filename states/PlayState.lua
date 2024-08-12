PlayState = Class {
    __includes = BaseState
}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 430

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

local pos = {1, 2, 2, 1, 1, 3, 2, 1, 2, 1, 1, 3, 3, 3, 2, 2, 1, 1, 1}

local i = 1
function PlayState:update(dt)
    if self.timer > 2 then
        local y = math.max(-PIPE_HEIGHT + 20, math.min(self.lastY + math.random(-20, 20), PIPE_HEIGHT / 3))

        randomX = VIRTUAL_WIDTH + 64 * pos[i]
        i = i + 1;
        if i > #pos then -- Reset to 1 if i exceeds the length of pos
            i = 1
        end
        table.insert(self.pipePairs, {
            -- flag to store whether we've scored the point for this pair of pipes
            scored = false,
            pipes = {Pipe('top', y, randomX), Pipe('bottom', y + PIPE_HEIGHT + 90, randomX)}
        })
        -- reset timer
        self.timer = 0
    end

    for k, pair in pairs(self.pipePairs) do
        local doRemove = false

        for l, pipe in pairs(pair.pipes) do
            if not pair.scored then
                if pipe.x + PIPE_WIDTH / 2 < self.bird.x then
                    self.score = self.score + 1
                    pair.scored = true
                    sounds['score']:play()
                end
            end

            if pipe.x > -72 then
                pipe.x = pipe.x - PIPE_SPEED * dt
            else
                doRemove = true
            end
        end

        if doRemove then
            table.remove(self.pipePairs, k)
        end
    end

    self.timer = self.timer + dt

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('title')
    end

    -- simple collision between bird and all pipes
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if (self.bird.x + 2) + (BIRD_WIDTH - 4) >= pipe.x and self.bird.x + 2 <= pipe.x + PIPE_WIDTH then
                if (self.bird.y + 2) + (BIRD_HEIGHT - 4) >= pipe.y and self.bird.y + 2 <= pipe.y + PIPE_HEIGHT then
                    sounds['explosion']:play()
                    sounds['hurt']:play()

                    gStateMachine:change('score', {
                        score = self.score
                    })
                end
            end
        end
    end

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change('score', {
            score = self.score
        })
    end

    self.bird:update(dt)
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            pipe:render()
        end
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end

function PlayState:enter()
    scrolling = true
end

function PlayState:exit()
    scrolling = false
end
