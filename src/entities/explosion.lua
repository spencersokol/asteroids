explosion = entity:extend({

    init = function(_ENV)

        entity.init(_ENV)

        x = x or 64
        y = y or 64
        max = max or 5
        min = 5

        parts = {}
        frames = 0
        max_frames = 15

        local c = (flr(rnd(max)) + min)

        for i = 1, c do

            local speed = rnd(2) + 1
            local rotation = rnd(1)

            add(parts, { 
                x = x, 
                y = y,
                x_velocity = cos(rotation) * speed,
                y_velocity = sin(rotation) * speed,
                frames = flr(rnd(max_frames)),
                clr = rnd({7, 9, 10})
            })
        end

    end,

    update = function(_ENV)

        entity.update(_ENV)

        frames += 1

        if (frames > max_frames) _ENV:destroy()

        for p in all(parts) do
            p.x += p.x_velocity
            p.y += p.y_velocity
            p.frames -= 1
        end

    end,
    
    draw = function(_ENV)

        for p in all(parts) do
            if (p.frames > 0) pset(p.x, p.y, p.clr)
        end

    end
    
})