game = scene:extend({

    init = function(_ENV)

        player = {}
        ships = {}
        
        frames = 0
        seconds_since_asteroid_spawn = 0
        seconds_since_ufo_spawn = 0

        score = 0

        bg = starfield:new()

        status("stars: " .. #bg.stars)

        player = player_ship:new()

        for i = 1, 3 do
            add_life(_ENV)
        end

        spawn_asteroids(_ENV, 7)

    end,

    update = function(_ENV)

        frames += 1
        
        if (frames > 30) then
            frames = 0
            seconds_since_asteroid_spawn += 1
            seconds_since_ufo_spawn += 1
        end

        if (should_spawn_asteroids(_ENV)) spawn_asteroids(_ENV)

        if (should_spawn_ufo(_ENV)) spawn_ufo(_ENV)

        local asteroids = {}
        local bullets = {}
        local current_ufo = nil
    
        -- update all and prep for collisions
        for e in all(entity.objects) do
            
            if (e:is(bullet)) then
                add(bullets, e)
            elseif (e:is(asteroid)) then
                add(asteroids, e)
            elseif (e:is(ufo)) then
                current_ufo = e
                status("ufo")
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
                if (("player" == b.source) and bullet_hits_asteroid(_ENV, b, a)) then
                    a:destroy()
                    b:destroy()
                    update_score(_ENV, a.score)
                end
            end

        end

        for b in all(bullets) do

            -- collisions
            if (current_ufo) then
                
                if (("ufo" == b.source) and bullet_hits_player(_ENV, b)) then
                    lose_life(_ENV)
                elseif (("player" == b.source) and bullet_hits_ufo(_ENV, b, current_ufo)) then
                    status("bullet hit ufo")
                    current_ufo:destroy()
                    b:destroy()
                    update_score(_ENV, current_ufo.score)
                end

            end

            -- bullets should only travel so far
            if (b.distance > 100) then
                b:destroy()
            end

        end

        if (current_ufo and ufo_hits_player(_ENV, current_ufo)) then
            lose_life(_ENV)
        end

        if (#ships == 0) and btnp(5) then
            scene:load(title)
        end

    end,

    draw = function(_ENV)

        cls()

        local asteroids = {}
        local current_ufo = nil

        -- draw everything but the stars first
        for e in all(entity.objects) do
            if (e:is(asteroid)) add(asteroids, e)
            if (e:is(ufo)) current_ufo = e
            if (not e:is(star)) e:draw()
        end

        for e in all(bg.stars) do

            local draw_star = true

            for a in all(asteroids) do
                if (star_behind_asteroid(_ENV, e, a)) then
                    draw_star = false
                    break
                end
            end

            if (star_behind_player(_ENV, e)) then
                draw_star = false
            end

            if (current_ufo and star_behind_ufo(_ENV, e, current_ufo)) then
                draw_star = false
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

    update_score = function(_ENV, points)

        local new_score = score + points

        if ((score < 5000) and (new_score >= 5000)) then
            add_life(_ENV)
        elseif ((score < 10000) and (new_score >= 10000)) then
            add_life(_ENV)
        end

        score += points

    end,

    add_life = function(_ENV)
        local s = ship:new({ x = (128 - ((#ships + 1) * 6)), y = 6 })
        add(ships, s)
    end,

    lose_life = function(_ENV)

        local s = ships[#ships]

        del(ships, s)
        
        s:destroy()
        player:kill()
                
    end,

    try_spawn_player = function(_ENV, asteroids)

        -- wait two full seconds_since_asteroid_spawn
        if (not (player.frames_since_death > 60)) return

        -- after 4 seconds_since_asteroid_spawn start dropping asteroids every two seconds_since_asteroid_spawn if player hasn't spawned
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

        if (not points_are_close(s.x, s.y, a.x, a.y)) return false

        -- return point_in_polygon(s.x, s.y, a:sides())
        return point_in_circle(s.x, s.y, a.x, a.y, a.radius)

    end,

    star_behind_ufo = function(_ENV, s, ufo)

        if (not points_are_close(s.x, s.y, ufo.x, ufo.y)) return false

        return point_in_polygon(s.x, s.y, ufo:sides())

    end,

    star_behind_player = function(_ENV, s)

        if (player.dead) return false

        if (not points_are_close(s.x, s.y, player.x, player.y)) return false

        -- return point_in_polygon(s.x, s.y, player:sides()) -- slow?
        return point_in_circle(s.x, s.y, player.x, player.y, 3)

    end,

    ufo_hits_player = function(_ENV, ufo)

        if (player.dead) return false
        
        local center = ufo:center()
        
        if (not points_are_close(center.x, center.y, player.x, player.y)) return false

        return polygon_in_polygon(ufo:sides(), player:sides())

    end,
    
    bullet_hits_ufo = function(_ENV, b, ufo)

        if (not points_are_close(b.x, b.y, ufo.x, ufo.y)) return false

        return point_in_polygon(b.x, b.y, ufo:sides())

    end,

    bullet_hits_player = function(_ENV, b)

        if (player.dead) return false
        
        if (not points_are_close(b.x, b.y, player.x, player.y)) return false

        return point_in_polygon(b.x, b.y, player:sides())

    end,

    bullet_hits_asteroid = function(_ENV, b, a)

        if (not points_are_close(b.x, b.y, a.x, a.y)) return false

        return point_in_circle(b.x, b.y, a.x, a.y, a.radius)
        -- return point_in_polygon(b.x, b.y, a:sides())
    end,

    asteroid_hits_player = function(_ENV, a)

        if (player.dead) return false

        if (not points_are_close(a.x, a.y, player.x, player.y)) return false

        return polygon_in_polygon(a:sides(), player:sides())

    end,

    should_spawn_ufo = function(_ENV)

        if (player.dead) return false

        -- 50% chance every 10 seconds
        if (seconds_since_ufo_spawn > 10) then
            seconds_since_ufo_spawn = 0
            return (rnd(1) > 0.5)
        end

        return false

    end,

    spawn_ufo = function(_ENV)

        local ufo_types = {
            ufo,
            ufo,
            ufo_large,
            ufo_large,
            ufo_large,
            ufo_large,
            ufo_large
        }
        local ufo_type = rnd(ufo_types)

        ufo_type:new()
        seconds_since_ufo_spawn = 0

    end,

    should_spawn_asteroids = function(_ENV)
        
        if (player.dead) return false

        if (score < 1000) then
            return (6 <= seconds_since_asteroid_spawn)
        elseif (score < 5000) then
            return (4 <= seconds_since_asteroid_spawn)
        elseif (score < 10000) then
            return (3 <= seconds_since_asteroid_spawn)
        end

        return (2 <= seconds_since_asteroid_spawn)

    end,

    spawn_count = function(_ENV)

        if (score < 1000) then
            return flr(rnd(2)) + 1
        elseif (score < 5000) then
            return flr(rnd(3)) + 1
        elseif (score < 10000) then
            return flr(rnd(4)) + 1
        end

        return flr(rnd(5)) + 1

    end,

    spawn_asteroids = function(_ENV, c)

        c = c or spawn_count(_ENV)

        local asteroid_types = { 
            asteroid,
            medium_asteroid,
            medium_asteroid,
            large_asteroid,
            large_asteroid,
            large_asteroid,
            large_asteroid
        }

        for i = 1, c do
            local asteroid_type = rnd(asteroid_types)
            asteroid_type:new()
        end

        seconds_since_asteroid_spawn = 0

    end

})