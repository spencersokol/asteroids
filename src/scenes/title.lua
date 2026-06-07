title = scene:extend({

    init = function(_ENV)

        starfield:new()

        highscore = dget(0)

        local c = flr(rnd(10)) + 10

        for i = 1, c do
            local asteroid_type = rnd({ asteroid, medium_asteroid, large_asteroid })
            asteroid_type:new()
        end

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

        cprint("Not Necessarily", 64, 36, 7)
        cprint("Asteroids", 64, 44, 7)

        if (highscore > 0) then
            cprint("high score:", 64, 108, 2)
            cprint(highscore, 64, 116, 2)
        end

        print("v" .. version, 127 - ((#version + 1) * 4), 120, 1)

    end
})