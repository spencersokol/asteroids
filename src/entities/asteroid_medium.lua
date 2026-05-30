medium_asteroid = asteroid:extend({

    score = 50,
    width = 7,
    variation = 3,

    -- add a chance of spawning small asteroid
    destroy = function(_ENV)

        entity.destroy(_ENV)

        if (rnd(1) > 0.5) then

            log("asteroid broke")

            asteroid:new({ x = x, y = y })

        end

    end

})