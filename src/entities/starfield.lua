starfield = entity:extend({

    -- "constants"
    label = "starfield",

    count = 0,

    init = function(_ENV)

        entity.init(_ENV)

        stars = {}

        count = rnd(40) + 20

        for i = 1, count do
            add(stars, star:new())
        end

    end,

    update = function(_ENV)

        entity.update(_ENV)

    end

})