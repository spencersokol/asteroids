star = entity:extend({
    
    -- "constants"
    label = "star",

    init = function(_ENV)

        entity.init(_ENV)

        colors = {0, 1, 5, 13}

        x = x or flr(rnd(127))
        y = y or flr(rnd(127))

        clr = rnd(colors)

        frames = 0

        -- max of 120 seconds min of 10
        interval = flr(rnd(30 * 120)) + 10

    end,

    update = function(_ENV)

        entity.update(_ENV)

        frames += 1

        if (frames == interval) then
            clr = rnd(colors)
            frames = 0
        end

    end,

    draw = function(_ENV)
        pset(x, y, clr)
    end,

    behind_asteroid = function(_ENV, a)

        if (not points_are_close(x, y, a.x, a.y)) return false

        -- return point_in_polygon(x, y, a:sides())
        return point_in_circle(x, y, a.x, a.y, a.radius)

    end,

    behind_ufo = function(_ENV, ufo)

        if (not points_are_close(x, y, ufo.x, ufo.y)) return false

        return point_in_polygon(x, y, ufo:sides())

    end,

    behind_player = function(_ENV, player)

        if (player.dead) return false

        if (not points_are_close(x, y, player.x, player.y)) return false

        -- return point_in_polygon(s.x, s.y, player:sides()) -- slow?
        return point_in_circle(x, y, player.x, player.y, 3)

    end

})