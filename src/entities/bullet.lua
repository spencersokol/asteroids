bullet = entity:extend({

    -- "constants"
    label = "bullet",

    init = function(_ENV)

        entity.init(_ENV)

        sfx(1)
        
        source = source or "player"

        if ("player" == source) then
            sfx(1)
        else
            sfx(1)
        end

        -- position
        x = x or 0
        y = y or 0
        rotation = rotation or 0

        -- movement
        speed = 3.5
        x_velocity = cos(rotation) * speed
        y_velocity = sin(rotation) * speed
        distance = 0

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
        pset(x, y, 7)
    end,

    destroy = function(_ENV)
        
        entity.destroy(_ENV)

    end,

    hits_ufo = function(_ENV, ufo)

        if (not points_are_close(x, y, ufo.x, ufo.y)) return false

        return point_in_polygon(x, y, ufo:sides())

    end,

    hits_player = function(_ENV, player)

        if (player.dead) return false
        
        if (not points_are_close(x, y, player.x, player.y)) return false

        return point_in_polygon(x, y, player:sides())

    end,

    hits_asteroid = function(_ENV, a)

        if (not points_are_close(x, y, a.x, a.y)) return false

        return point_in_circle(x, y, a.x, a.y, a.radius)
        -- return point_in_polygon(b.x, b.y, a:sides())
    end,


})