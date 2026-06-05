ufo_large = ufo:extend({

    label = "ufo_large",
    
    init = function(_ENV)

        entity.init(_ENV)

        reset(_ENV)
        
        score = 500

        sfx(3)

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

        spr(1, x, y)
        spr(2, x + 8, y)

    end,

    destroy = function(_ENV)

        sfx(3, -2)

        entity.destroy(_ENV)

        if (dead) then
                
            sfx(2)
            explosion:new({ x = x, y = y, max = 25 })

        end

    end,

    center = function(_ENV)
        return { x = x + 8, y = y + 4 }
    end,

    sides = function(_ENV)

        -- draw outline based on sprite
        return {
            { x1 = x, y1 = y + 3, x2 = x + 1, y2 = y + 3 },
            { x1 = x + 1, y1 = y + 3, x2 = x + 4, y2 = y },
            { x1 = x + 4, y1 = y, x2 = x + 11, y2 = y },
            { x1 = x + 11, y1 = y, x2 = x + 14, y2 = y + 3 },
            { x1 = x + 14, y1 = y + 3, x2 = x + 15, y2 = y + 3 },
            { x1 = x + 15, y1 = y + 3, x2 = x + 11, y2 = y + 7 },
            { x1 = x + 11, y1 = y + 7, x2 = x + 4, y2 = y + 7 },
            { x1 = x + 4, y1 = y + 7, x2 = x, y2 = y + 3 }
        }

    end

})