large_asteroid = asteroid:extend({

    score = 20,
    radius = 10,
    variation = 5,
    hit_buffer = 5,

    -- add a chance of spawning smaller asteroids
    destroy = function(_ENV)

        entity.destroy(_ENV)

        sfx(2)
        
        if (rnd(1) > 0.1) then

            -- small or medium asteroid
            local asteroid_type = rnd({ asteroid, medium_asteroid })

            asteroid_type:new({ x = x, y = y })

            if (rnd(1) > 0.5) then
                
                -- small asteroid
                asteroid:new({ x = x, y = y })

            end

        else
            explosion:new({ x = x, y = y, max = 15 })
        end
        
    end

})