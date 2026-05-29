bullet = entity:extend({

    -- "constants"
    label = "bullet",


    -- position
    x = 0,
    y = 0,
    rotation = 0,

    -- movement
    speed = 5,
    x_velocity = 0,
    y_velocity = 0,
    distance = 0,

    init = function(_ENV)

        entity.init(_ENV)

        x_velocity = cos(rotation) * speed
        y_velocity = sin(rotation) * speed

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
        pset(x, y)
    end,

    destroy = function(_ENV)
        
        entity.destroy(_ENV)

        gamestate.bullet_count -= 1

    end

})