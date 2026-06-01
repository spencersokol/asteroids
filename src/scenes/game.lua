game = scene:extend({

    init = function(_ENV)

        player = {}
        ships = {}

        frames = 0
        seconds = 0 -- since last asteroid spawn

        score = 0

        bg = starfield:new()

        player = player_ship:new()

        for i = 1, 3 do
            local s = ship:new({ x = (128 - (i * 6)), y = 6 })
            add(ships, s)
        end

        spawn_asteroids(_ENV, 7)

    end,

    update = function(_ENV)

        frames += 1
        
        if (frames > 30) then
            frames = 0
            seconds += 1
        end

        if (should_spawn_asteroids(_ENV)) spawn_asteroids(_ENV)

        local asteroids = {}
        local bullets = {}

        -- update all and prep for collisions
        for e in all(entity.objects) do
            
            if (e:is(bullet)) then
                add(bullets, e)
            elseif (e:is(asteroid)) then
                add(asteroids, e)
            end

            e:update()

        end

        if (player.dead and (#ships > 0)) try_spawn_player(_ENV, asteroids)

        -- check collisions
        for a in all(asteroids) do

            if asteroid_hits_player(_ENV, a) then

                local msg = "p: " .. flr(player.x) .. "," .. flr(player.y) .. " : "
                msg = msg .. "a: " .. flr(a.x) .. "," .. flr(a.y) .. " " .. a.radius

                status(msg)
                
                a.is_killer = true

                lose_life(_ENV)

            end

            for b in all(bullets) do
                if bullet_hits_asteroid(_ENV, b, a) then
                    a:destroy()
                    b:destroy()
                    score += a.score
                end
            end
        end

        -- bullets should only travel so far
        for b in all(bullets) do
            
            if (b.distance > 130) then
                b:destroy()
            end

        end

        if (#ships == 0) and btnp(5) then
            scene:load(title)
        end

    end,

    draw = function(_ENV)
        cls()

        local asteroids = {}

        -- draw everything but the stars first
        for e in all(entity.objects) do
            if (e:is(asteroid)) add(asteroids, e)
            if (not e:is(star)) e:draw()
        end

        for e in all(bg.stars) do
            local draw_star = true
            for a in all(asteroids) do
                if (star_behind_asteroid(_ENV, e, a)) then
                    draw_star = false
                    break
                end
                if (star_behind_player(_ENV, e, a)) then
                    draw_star = false
                    break
                end
            end
            if (draw_star) e:draw()
        end

        print("score: " .. score, 1, 1, 7)

        if (#ships == 0) then
            print("\#0game over", 50, 64, 7)
        end

    end,

    destroy = function(_ENV)
        scene.destroy(_ENV)
    end,

    lose_life = function(_ENV)

        local s = ships[#ships]
        del(ships, s)
        s:destroy()
        player:kill()
                
    end,

    try_spawn_player = function(_ENV, asteroids)

        -- wait two full seconds
        if (not (player.frames_since_death > 60)) return

        -- after 4 seconds start dropping asteroids every two seconds if player hasn't spawned
        if ((player.frames_since_death > 120) and (0 == (player.frames_since_death % 60))) then
            local a = asteroids[#asteroids]
            a:destroy()
            del(asteroids, a)
        end

        local buffer = 20

        -- give player a buffer in all directions
        for a in all(asteroids) do
            if ((a.x > (64 - buffer) and a.x < (64 + buffer)) and (a.y > (64 - buffer) and a.y < (64 + buffer))) return
        end

        player:reset()

    end,

    star_behind_asteroid = function(_ENV, s, a)
        return point_in_circle(s.x, s.y, a.x, a.y, a.radius)
    end,

    star_behind_player = function(_ENV, s)
        return point_in_circle(s.x, s.y, player.x, player.y, 3)
    end,

    bullet_hits_asteroid = function(_ENV, b, a)
        -- use point/circle collision detection
        return point_in_circle(b.x, b.y, a.x, a.y, a.radius)
    end,

    asteroid_hits_player = function(_ENV, a)

        if (player.dead) return false

        -- add a buffer here to be a little forgiving
        local radius = a.radius - a.hit_buffer

        -- check the points first
        local front = point_in_circle(player.front.x, player.front.y, a.x, a.y, radius)
        local rear_left = point_in_circle(player.rear_left.x, player.rear_left.y, a.x, a.y, radius)
        local rear_right = point_in_circle(player.rear_right.x, player.rear_right.y, a.x, a.y, radius)

        if (front or rear_left or rear_right) return true

        --[[
        -- check the lines
        local side1 = line_in_circle(
            player.front.x,
            player.front.y,
            player.rear_left.x,
            player.rear_left.y,
            a.x,
            a.y,
            radius
        )
        local side2 = line_in_circle(
            player.front.x,
            player.front.y,
            player.rear_right.x,
            player.rear_right.y,
            a.x,
            a.y,
            radius
        )
        local side3 = line_in_circle(
            player.rear_left.x,
            player.rear_left.y,
            player.rear_right.x,
            player.rear_right.y,
            a.x,
            a.y,
            radius
        )
        
        if (side1 or side2 or side3) return true
        ]]

        return false

    end,

    should_spawn_asteroids = function(_ENV)
        
        if (player.dead) return

        if (score < 1000) then
            return (6 <= seconds)
        elseif (score < 5000) then
            return (4 <= seconds)
        elseif (score < 10000) then
            return (3 <= seconds)
        end

        return (2 <= seconds)

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

    spawn_asteroids = function(_ENV, c)

        c = c or spawn_count(_ENV)

        local asteroid_types = { asteroid, medium_asteroid, large_asteroid }

        for i = 1, c do
            local asteroid_type = rnd(asteroid_types)
            asteroid_type:new()
        end

        seconds = 0

    end

})