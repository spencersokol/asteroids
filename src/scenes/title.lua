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

        rectfill(23, 18, 104, 50, 6)
        rectfill(24, 19, 103, 49, 0)

        pset(23, 18, 0)
        pset(23, 50, 0)
        pset(104, 18, 0)
        pset(104,50, 0)

        if (highscore > 0) then
            scprint("high score:" .. tostr(highscore), 64, 8, 7)
        end

        for i = 34, 42 do
            spr(i, 28 + ((i - 34) * 8), 30)
        end

        for i = 50, 58 do
            spr(i, 28 + ((i - 50) * 8), 38)
        end

        print("\#2not necessarily", 19, 23, 7)

        if (frames > 15) then
            cprint("press any key to start", 64, 80, blink())
        end

        scprint("turn: ⬅️➡️ thrust: ⬆️ fire: 🅾️", 56, 100, 7)

        print("v" .. version, 127 - ((#version + 1) * 4), 120, 1)

    end
})