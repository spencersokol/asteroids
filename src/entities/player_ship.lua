player_ship = ship:extend({

    -- "constants"
    label = "player_ship",

    reset = function(_ENV)

        dead = false
        frames_since_death = 0

        x = 64
        y = 64

        rotation = 0

        thrusting = false
        x_velocity = 0
        y_velocity = 0

        front = { x = 0, y = 0 }
        rear = { x = 0, y = 0 }
        rear_left = { x = 0, y = 0 }
        rear_right = { x = 0, y = 0 }
        
    end,

    kill = function(_ENV)
        
        sfx(0)

        dead = true

        explosion:new({ 
            x = x,
            y = y 
        })

    end,

    init = function(_ENV)

        entity.init(_ENV)

        frames_since_death = 0

        front_distance = 5
        rear_distance = 3
        side_distance = 3

        rotation = 0

        bullet_max = 3

        friction = 0.92
        speed = 1.5
        rotation_speed = 0.02

        dead = false

        _ENV:reset()
        _ENV:calculate_border_points()

    end,

    update = function(_ENV)
        
        entity.update(_ENV)

        if (dead) then
            frames_since_death += 1
            return
        end

        -- handle movement input
        if btn(2) then
            thrusting = true
            x_velocity = cos(rotation) * speed
            y_velocity = sin(rotation) * speed
        else -- slow down over time
            thrusting = false
            x_velocity *= friction
            y_velocity *= friction
        end

        -- handle rotation input
        if btn(0) then
            rotation += rotation_speed
        end
        
        if btn(1) then
            rotation -= rotation_speed
        end

        -- handle fire
        if btnp(4) then

            local bullet_count = 0

            for e in all(entity.objects) do
                if (e:is(bullet)) bullet_count += 1
            end

            if (bullet_count < bullet_max) then

                bullet:new({
                    x = front.x,
                    y = front.y,
                    rotation = rotation
                })

            end

        end

        -- update position
        x += x_velocity
        y += y_velocity

        -- don't go off screen
        if (x > 128) x = 0
        if (x < 0) x = 128
        if (y > 128) y = 0
        if (y < 0) y = 128

        _ENV:calculate_border_points()

    end,

    draw = function(_ENV)

        if (not dead) then
            
            if (thrusting) then

                local len = rnd(3) + 1
                local lenx = x + (cos(rotation) * -(rear_distance + len)) -- - (sin * 0)
                local leny = y + (sin(rotation) * -(rear_distance + len)) -- + (cos * 0)

                line(rear.x, rear.y, lenx, leny, rnd({7, 9, 10}))
                
            end

            ship.draw(_ENV)

        end

    end

})