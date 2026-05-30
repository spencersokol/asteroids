gamestate = gameobject:extend({

    player_dead = false,
    bullet_count = 0,
    bullet_max = 3,
    lives = 3,
    score = 0,
    frames = 0,
    seconds = 0, -- since last asteroid spawn

    should_spawn_asteroids = function(_ENV)
        
        if (player_dead) return

        if (score < 1000) then
            return (6 == seconds)
        elseif (score < 5000) then
            return (4 == seconds)
        elseif (score < 10000) then
            return (3 == seconds)
        end

        return (2 == seconds)

    end,

    spawn_count = function(_ENV)

        if (score < 1000) then
            return flr(rnd(2)) + 1
        elseif (score < 5000) then
            return flr(rnd(4)) + 1
        elseif (score < 10000) then
            return flr(rnd(6)) + 1
        end

        return flr(rnd(8))

    end,

    spawn_asteroids = function(_ENV, spawn_count)

        spawn_count = spawn_count or _ENV:spawn_count()

        local asteroid_types = { asteroid, medium_asteroid, large_asteroid }

        log("adding " .. spawn_count .. " asteroids")

        for i = 1, spawn_count do
            local asteroid_type = rnd(asteroid_types)
            asteroid_type:new()
        end

        seconds = 0

    end,

    init = function(_ENV)

        bullet_count = 0
        bullet_max = 3
        lives = 3
        score = 0
        frames = 0
        seconds = 0

        _ENV:spawn_asteroids(7)

    end,

    update = function(_ENV)

        frames += 1
        
        if (frames > 30) then
            frames = 0
            seconds += 1
            -- log("gamestate: 1 second elapsed")
        end

        if (_ENV:should_spawn_asteroids()) _ENV:spawn_asteroids()

    end,

    destroy = function(_ENV)

    end

})