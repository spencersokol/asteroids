title = scene:extend({

    init = function(_ENV)
        starfield:new()
    end,

    update = function(_ENV)

        for e in all(entity.objects) do
            e:update()
        end

        if btnp(5) then 
            scene:load(game)
        end

    end,

    draw = function(_ENV)

        cls()

        for e in all(entity.objects) do
            e:draw()
        end

        print("Not Necessarily", 35, 36, 7)
        print("Asteroids", 48, 44, 7)

    end
})