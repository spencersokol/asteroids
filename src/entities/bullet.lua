bullet = entity:extend({

    -- "constants"
    label = "bullet",

    init = function(_ENV)

        entity.init(_ENV)

        -- position
        x = x or 0
        y = y or 0
        rotation = rotation or 0

        -- movement
        speed = 5
        x_velocity = cos(rotation) * speed
        y_velocity = sin(rotation) * speed
        distance = 0

    end,

    update = function(_ENV)

        entity.update(_ENV)

        -- update position
        x += x_velocity
        y += y_velocity

        -- don't go off screen
        if (x > 128) x = 0
        if (x < 0) x = 128
        if (y > 128) y = 0
        if (y < 0) y = 128

        distance += 1 * speed

    end,

    draw = function(_ENV)
        pset(x, y, 7)
    end,

    destroy = function(_ENV)
        
        entity.destroy(_ENV)

    end

})