asteroid = entity:extend({

    label = "asteroid",

    score = 100,
    width = 4,
    variation = 2,
    x = 0,
    y = 0,
    buffer = 0,
    points = {},
    min_points = 8,
    rotation = 0,
    speed = 0,
    spin = 0,
    spin_speed = 0,
    x_velocity = 0,
    y_velocity = 0,
    is_killer = false,

    find_start = function(_ENV)

        -- start position provided
        if (x > 0) return
            
        -- probably a better way to do this whole thing

        -- center screen
        x = 64
        y = 64

        -- need to essentially reverse velocity
        -- to get a good starting point
        local x_sign = x_velocity >= 0 and -1 or 1
        local y_sign = y_velocity >= 0 and -1 or 1

        -- figure out the multiplier to get from
        -- the center point to off screen
        local x_multiplier = ((64 + buffer)/x_velocity)
        local y_multiplier = ((64 + buffer)/y_velocity)
        
        -- log("x_multiplier: " .. x_multiplier)
        -- log("y_multiplier: " .. y_multiplier)

        -- get the starting point by using the smallest multiplier
        if (abs(x_multiplier) < abs(y_multiplier)) then
            x += flr(x_multiplier * x_velocity) * x_sign
            y += flr(x_multiplier * y_velocity) * y_sign
        else
            x += flr(y_multiplier * x_velocity) * x_sign
            y += flr(y_multiplier * y_velocity) * y_sign
        end

    end,

    init = function(_ENV)

        entity.init(_ENV)

        points = {}

        -- generate random starting info, with position away from ship
        speed = rnd(0.75) + 0.25
        rotation = rnd(1)
        spin_speed = rnd(0.015)

        buffer = width + variation + 10

        x_velocity = cos(rotation) * speed
        y_velocity = sin(rotation) * speed

        _ENV:find_start()

        log("asteroid.position: " .. x .. "," .. y)
        log("asteroid.rotation: " .. rotation)
        log("asteroid.velocity: " .. x_velocity .. "," .. y_velocity)

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

        -- update position and spin
        x += x_velocity
        y += y_velocity

        spin += spin_speed


        -- don't go too far off screen
        -- use a buffer so the asteroid goes off screen though
        local lower = 0 - buffer
        local upper = 128 + buffer

        if (x > upper) x = lower
        if (x < lower) x = upper
        if (y > upper) y = lower
        if (y < lower) y = upper

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
                y + sin(r2 + spin) * d2,
                7
            )

        end
    end,

})
