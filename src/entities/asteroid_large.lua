large_asteroid = asteroid:extend({

    score = 20,
    width = 10,
    variation = 5,

    -- add a chance of spawning smaller asteroids
    destroy = function(_ENV)

        entity.destroy(_ENV)

        if (rnd(1) > 0.1) then

            log("asteroid broke")

            -- small or medium asteroid
            local asteroid_type = rnd({ asteroid, medium_asteroid })

            asteroid_type:new({ x = x, y = y })

            if (rnd(1) > 0.5) then
                
                -- small asteroid
                asteroid:new({ x = x, y = y })

            end

        end
        
    end

})