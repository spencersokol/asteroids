ufo_large = ufo:extend({

    label = "ufo_large",
    
    init = function(_ENV)

        entity.init(_ENV)

        reset(_ENV)
        
        score = 500

    end,

    update = function(_ENV)

        entity.update(_ENV)

        handle_frames(_ENV)
        
        handle_rotation(_ENV)

        local xc = ltr and (x + 3) or (x - 3)

        handle_firing(_ENV, x, y + 2)

        handle_movement(_ENV)

    end,

    draw = function(_ENV)

        spr(1, x - 4, y - 4)
        spr(2, x + 4, y - 4)

    end

})