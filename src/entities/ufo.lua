ufo = entity:extend({
     
    label = "ufo",

    reset = function(_ENV)

        score = 200

        buffer = 20

        target = target or nil

        dead = false

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

        y = flr(rnd(90)) + 15

        frames = 0
        frames_since_firing = 0

        speed = 0.8

        x_velocity = 0
        y_velocity = 0

    end,

    init = function(_ENV)

        entity.init(_ENV)

        reset(_ENV)

        sfx(4)

    end,

    update = function(_ENV)

        entity.update(_ENV)

        handle_frames(_ENV)

        handle_rotation(_ENV)

        local xc = ltr and (x + 6) or (x - 6)

        handle_firing(_ENV, xc, y + 2)

        handle_movement(_ENV)

    end,

    draw = function(_ENV)

        spr(3, x, y)

    end,

    destroy = function(_ENV)

        sfx(4, -2)

        entity.destroy(_ENV)

        if (dead) then

            sfx(2)
            explosion:new({ x = x, y = y, max = 15 })

        end

    end,

    center = function(_ENV)
        return { x = x + 4, y = y + 4 }
    end,

    sides = function(_ENV)

        -- draw outline based on sprite
        return {
            { x1 = x, y1 = y + 3, x2 = x + 3, y2 = y },
            { x1 = x + 3, y1 = y, x2 = x + 4, y2 = y },
            { x1 = x + 4, y1 = y, x2 = x + 7, y2 = y + 3 },
            { x1 = x + 7, y1 = y + 3, x2 = x + 5, y2 = y + 7 },
            { x1 = x + 5, y1 = y + 7, x2 = x + 2, y2 = y + 7 },
            { x1 = x + 2, y1 = y + 7, x2 = x, y2 = y + 4 }
        }

    end,

    hits_player = function(_ENV, player)

        if (player.dead) return false
        
        local center = center(_ENV)
        
        if (not points_are_close(center.x, center.y, player.x, player.y)) return false

        return polygon_in_polygon(sides(_ENV), player:sides())

    end,
    
    handle_frames = function(_ENV)

        frames += 1
        frames_since_firing += 1

    end,

    handle_rotation = function(_ENV)

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

    end,

    handle_firing = function(_ENV, xcoord, ycoord)

        if ((frames_since_firing % 30) == 0) then

            if (not target) then

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
                        x = xcoord,
                        y = ycoord,
                        rotation = r
                    })

                    frames_since_firing = 0

                end

            else

                local dx = target.x - x
                local dy = target.y - y

                -- fire at the target
                bullet:new({
                    source = "ufo",
                    x = xcoord,
                    y = ycoord,
                    rotation = atan2(dx, dy)
                })

            end

        end

    end,

    handle_movement = function(_ENV)

        -- update velocity
        x_velocity = cos(rotation) * speed
        y_velocity = sin(rotation) * speed

        -- update position
        x += x_velocity
        y += y_velocity

        -- kill it if it makes it across the screen
        if (ltr and (x > (127 + buffer))) or (not ltr and (x < -buffer)) then
            destroy(_ENV)
        end
        
    end

})