asteroid = entity:extend({

    label = "asteroid",

    x = 0,
    y = 0,
    width = 7,
    variation = 3,
    points = {},
    min_points = 8,
    rotation = 0,
    speed = 0,
    spin = 0,
    spin_speed = 0,
    x_velocity = 0,
    y_velocity = 0,

    init = function(_ENV)

        entity.init(_ENV)

        points = {}

        -- generate random starting info, with position away from ship
        speed = rnd(0.75) + 0.25
        rotation = rnd()
        spin_speed = rnd(0.015)

        x = cos(rotation) * -256
        y = sin(rotation) * -256

        x_velocity = cos(rotation) * speed
        y_velocity = sin(rotation) * speed

        -- generate random number of points based on size
        local num_points = flr(rnd(5)) + width

        if (num_points < min_points) num_points = min_points

        for i = 1, num_points do
            local distance = width - (flr(rnd(variation)) + 1)
            add(points, distance)
        end

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

        spin += spin_speed

    end,

    draw = function(_ENV)

        for i = 1, #points do

            local j = i + 1
            if (j > #points) j = 1

            local d1 = points[i]
            local d2 = points[j]
            
            local r1 = i/#points -- rotation
            local r2 = j/#points -- rotation

            line(
                x + cos(r1 + spin) * d1,
                y + sin(r1 + spin) * d1,
                x + cos(r2 + spin) * d2,
                y + sin(r2 + spin) * d2
            )

        end
    end,

})

small_asteroid = asteroid:extend({
    width = 4,
    variation = 2
})

large_asteroid = asteroid:extend({
    width = 10,
    variation = 5
})