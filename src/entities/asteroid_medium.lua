medium_asteroid = asteroid:extend({

    score = 50,
    radius = 7,
    variation = 3,
    hit_buffer = 3,

    -- add a chance of spawning small asteroid
    destroy = function(_ENV)

        entity.destroy(_ENV)

        if (rnd(1) > 0.5) then

            asteroid:new({ x = x, y = y })

        else 
            explosion:new({ x = x, y = y, max = 8 })
        end

    end

})