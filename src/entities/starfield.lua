starfield = entity:extend({

    -- "constants"
    label = "starfield",

    init = function(_ENV)

        entity.init(_ENV)

        stars = {}

        local star_count = flr(rnd(40)) + 40

        for i = 1, star_count do
            add(stars, star:new())
        end

    end,

})