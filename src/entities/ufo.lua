ufo = entity:extend({
     
    label = "ufo",

    init = function(_ENV)

        entity.init(_ENV)

        score = 200
        buffer = 20

        -- start from left
        ltr = true
        x = -buffer
        rotation = 0

        if (rnd(1) > 0.5) then

            -- start from right
            ltr = false
            x = 127 + buffer
            rotation = 0.5

        end

        y = flr(rnd(127))

        frames = 0
        frames_since_firing = 0

        speed = 0.8

        x_velocity = 0
        y_velocity = 0

    end,

    update = function(_ENV)

        entity.update(_ENV)

        frames += 1
        frames_since_firing += 1

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

        if ((frames_since_firing % 20) == 0) then

            if (rnd() > 0.65) then

                -- shoot toward the diagonal direction
                -- from the current position
                local q1 = (x >= 64) and (y <= 64)
                local q2 = (x <= 64) and (y <= 64)
                local q4 = (x >= 64) and (y >= 64)
                
                local r = rnd(0.25)

                if (q1) then
                    r += 0.5
                elseif (q2) then
                    r += 0.75
                elseif (q4) then 
                    r = 0.25
                end

                bullet:new({
                    source = "ufo",
                    x = x,
                    y = y,
                    rotation = r
                })

                frames_since_firing = 0

            end

        end

        -- update velocity
        x_velocity = cos(rotation) * speed
        y_velocity = sin(rotation) * speed

        -- update position
        x += x_velocity
        y += y_velocity

        if (ltr and (x > (127 + buffer))) or (not ltr and (x < -buffer)) then
            entity.destroy(_ENV)
        end
        
    end,

    draw = function(_ENV)

        rectfill(x - 3, y - 3, x + 3, y + 3, 8)

    end,

})