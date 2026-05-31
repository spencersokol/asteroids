starfield = entity:extend({

    -- "constants"
    label = "starfield",

    star_count = 0,

    init = function(_ENV)

        entity.init(_ENV)

        stars = {}

        star_count = rnd(40) + 20

        for i = 1, star_count do
            add(stars, star:new())
        end

    end,

    update = function(_ENV)

        entity.update(_ENV)

    end

})