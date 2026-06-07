title = scene:extend({

    init = function(_ENV)

        starfield:new()

        frames = 0
        highscore = dget(0)

        local c = flr(rnd(10)) + 10

        for i = 1, c do
            local asteroid_type = rnd({ asteroid, medium_asteroid, large_asteroid })
            asteroid_type:new()
        end

    end,

    update = function(_ENV)

        frames += 1

        for e in all(entity.objects) do
            e:update()
        end

        if ((frames > 15) and (btnp(❎) or btnp(🅾️))) then 
            scene:load(game)
        end

    end,

    draw = function(_ENV)

        cls()

        for e in all(entity.objects) do
            e:draw()
        end

        if (highscore > 0) then
            cprint("high score: " .. tostr(highscore), 64, 4, 2)
        end

        cprint("Not Necessarily", 64, 36, 7)
        cprint("Asteroids", 64, 44, 7)

        if (frames > 15) then
            cprint("press any key to start", 64, 80, blink())
        end

        cprint("turn: ⬅️➡️ thrust: ⬆️ fire: 🅾️", 56, 100, 7)

        print("v" .. version, 127 - ((#version + 1) * 4), 120, 1)

    end
})