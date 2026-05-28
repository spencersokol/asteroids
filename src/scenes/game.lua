game = scene:extend({
    init = function(_ENV)
        ship:new()
    end,

    update = function(_ENV)

        -- decide on what objects to actually draw first
        -- this just tries to draw everything
        for i = #entity.objects, 1, -1 do
            
            local e = entity.objects[i]

            e:update()

            -- bullets should only travel so far
            if (e:is(bullet) and e.distance > 130) del(entity.objects, e)

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

    end
})