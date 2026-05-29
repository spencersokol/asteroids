game = scene:extend({

    init = function(_ENV)

        local asteroid_types = { small_asteroid, asteroid, large_asteroid }

        ship:new()

        for i = 1, 7 do
            local asteroid_type = rnd(asteroid_types)
            asteroid_type:new()
        end

    end,

    update = function(_ENV)

        for i = #entity.objects, 1, -1 do
            
            local e = entity.objects[i]

            e:update()

            -- do collisions

            -- bullets should only travel so far
            if (e:is(bullet) and e.distance > 130) then
                gamestate.bullet_count -= 1
                -- del(entity.objects, e)
                entity.destroy(e)
            end

        end

        if btnp(5) then
            scene:load(title)
        end
    end,

    draw = function(_ENV)
        cls()

        -- decide on what objects to actually draw first
        -- this just tries to draw everything
        for e in all(entity.objects) do
            e:draw()
        end

    end,

    destroy = function(_ENV)
        gamestate:destroy()
    end
})