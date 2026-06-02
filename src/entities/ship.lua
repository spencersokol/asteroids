ship = entity:extend({

    label = "ship",

    calculate_border_points = function(_ENV)

        -- calculate various border points
        local cos = cos(rotation)
        local sin = sin(rotation)

        front.x = x + (cos * front_distance) -- - (sin * 0)
        front.y = y + (sin * front_distance) -- + (cos * 0)
        center_left.x = x + 0 - (sin * (side_distance * 0.65))
        center_left.y = y + 0 + (cos * (side_distance * 0.65))
        center_right.x = x + 0 - (sin * -(side_distance * 0.65))
        center_right.y = y + 0 + (cos * -(side_distance * 0.65))
        rear.x = x + (cos * -rear_distance) -- - (sin * 0)
        rear.y = y + (sin * -rear_distance) -- + (cos * 0)
        rear_left.x = x + (cos * -rear_distance) - (sin * side_distance)
        rear_left.y = y + (sin * -rear_distance) + (cos * side_distance)
        rear_right.x = x + (cos * -rear_distance) - (sin * -side_distance)
        rear_right.y = y + (sin * -rear_distance) + (cos * -side_distance)

    end,

    init = function(_ENV)

        entity.init(_ENV)

        front_distance = front_distance or 3
        rear_distance = rear_distance or 2
        side_distance = side_distance or 2

        rotation = 0.25

        x = x or 64
        y = y or 64

        front = { x = 0, y = 0 }
        center_left = { x = 0, y = 0 }
        center_right = { x = 0, y = 0 }
        rear = { x = 0, y = 0 }
        rear_left = { x = 0, y = 0 }
        rear_right = { x = 0, y = 0 }

        _ENV:calculate_border_points()

    end,

    draw = function(_ENV) 

        line(front.x, front.y, rear_left.x, rear_left.y, 7)
        line(front.x, front.y, rear_right.x, rear_right.y, 7)
        line(rear_left.x, rear_left.y, rear_right.x, rear_right.y, 7)
        
    end,

})