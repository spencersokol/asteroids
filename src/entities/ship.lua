ship = entity:extend({

    -- "constants"
    label = "ship",

    front_distance = 5,
    rear_distance = 3,
    side_distance = 3,

    friction = 0.92,
    speed = 1.5,
    rotation_speed = 0.03,

    -- position
    x = 64,
    y = 64,
    front = { x = 0, y = 0 },
    rear = { x = 0, y = 0 },
    rear_left = { x = 0, y = 0 },
    rear_right = { x = 0, y = 0 },
    rotation = 0,

    -- movement
    velocity = { x = 0, y = 0 },

    calculate_border_points = function(_ENV)

        -- calculate various border points
        local cos = cos(rotation)
        local sin = sin(rotation)

        front.x = x + (cos * front_distance) -- - (sin * 0)
        front.y = y + (sin * front_distance) -- + (cos * 0)
        rear.x = x + (cos * rear_distance) -- - (sin * 0)
        rear.y = y + (sin * rear_distance) -- + (cos * 0)
        rear_left.x = x + (cos * -rear_distance) - (sin * side_distance)
        rear_left.y = y + (sin * -rear_distance) + (cos * side_distance)
        rear_right.x = x + (cos * -rear_distance) - (sin * -side_distance)
        rear_right.y = y + (sin * -rear_distance) + (cos * -side_distance)

    end,

    init = function(_ENV)

        entity.init(_ENV)

        x = 64
        y = 64

        rotation = 0

        velocity.x = 0
        velocity.y = 0

        _ENV:calculate_border_points()

    end,

    update = function(_ENV)
        
        entity.update(_ENV)

        -- handle movement input
        if btn(2) then
            velocity.x = cos(rotation) * speed
            velocity.y = sin(rotation) * speed
        else -- slow down over time
            velocity.x *= friction
            velocity.y *= friction
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

            if (gamestate.bullet_count < gamestate.bullet_max) then

                bullet:new({
                    x = front.x,
                    y = front.y,
                    rotation = rotation
                })

                gamestate.bullet_count += 1
                
            end
        end

        -- update position
        x += velocity.x
        y += velocity.y

        -- don't go off screen
        if (x > 128) x = 0
        if (x < 0) x = 128
        if (y > 128) y = 0
        if (y < 0) y = 128

        _ENV:calculate_border_points()

    end,

    draw = function(_ENV) 

        line(front.x, front.y, rear_left.x, rear_left.y)
        line(front.x, front.y, rear_right.x, rear_right.y)
        line(rear_left.x, rear_left.y, rear_right.x, rear_right.y)
        
    end,

})