bullet = entity:extend({

    -- "constants"
    label = "bullet",


    -- position
    x = 0,
    y = 0,
    rotation = 0,

    -- movement
    speed = 5,
    velocity = { x = 0, y = 0 },
    distance = 0,

    init = function(_ENV)

        entity.init(_ENV)

        velocity.x = cos(rotation) * speed
        velocity.y = sin(rotation) * speed

    end,

    update = function(_ENV)

        entity.update(_ENV)

        -- update position
        x += velocity.x
        y += velocity.y

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

})