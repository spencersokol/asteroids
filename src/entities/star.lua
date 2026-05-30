star = entity:extend({
    
    -- "constants"
    label = "star",

    colors = {1, 5, 13},

    x = 0,
    y = 0,
    clr = 0,
    frames = 0,
    interval = 0,

    init = function(_ENV)

        entity.init(_ENV)

        x = flr(rnd(127))
        y = flr(rnd(127))

        clr = rnd(colors)

        frames = 0

        -- max of 120 seconds min of 10
        interval = flr(rnd(30 * 120)) + 10

    end,

    update = function(_ENV)

        entity.update(_ENV)

        frames += 1

        if (frames == interval) then
            clr = rnd(colors)
            frames = 0
        end

    end,

    draw = function(_ENV)
        pset(x, y, clr)
    end

})