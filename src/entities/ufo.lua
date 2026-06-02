ufo = entity:extend({
     
    label = "ufo",

    init = function(_ENV)

        entity.init(_ENV)

        score = 200

        -- start from left
        ltr = true
        x = -20
        rotation = 0

        if (rnd(1) > 0.5) then

            -- start from right
            ltr = false
            x = 147
            rotation = 0.5

        end

        y = flr(rnd(127))

        frames = 0

        speed = 0.8

        x_velocity = 0
        y_velocity = 0

    end,

    update = function(_ENV)

        entity.update(_ENV)

        frames += 1

        if (frames >= 30) then

            -- go up or down a bit if we've been straight a moment
            if ((0 == rotation) or (0.5 == rotation)) then
                if (rnd(1) > 0.8) then
                    if (ltr) then
                        rotation = (y > 64) and 0.125 or 0.875
                    else
                        rotation = (y > 64) and 0.375 or 0.625
                    end
                    frames = 0
                end
            else
                rotation = ltr and 0 or 0.5
                frames = 0
            end

        end

        -- update velocity
        x_velocity = cos(rotation) * speed
        y_velocity = sin(rotation) * speed

        -- update position
        x += x_velocity
        y += y_velocity

    end,

    draw = function(_ENV)

        rectfill(x - 3, y - 3, x + 3, y + 3, 8)

    end,

})