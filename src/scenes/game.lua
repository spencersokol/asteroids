game = scene:extend({

    init = function(_ENV)

        player = {}
        ships = {}
        
        frames = 0
        seconds_since_asteroid_spawn = 0
        seconds_since_ufo_spawn = 0
        seconds_since_game_over = 0

        score = 0
        highscore = dget(0)
        newhighscore = false

        player = player_ship:new()

        bg = starfield:new()

        status("stars: " .. #bg.stars)

        for i = 1, 3 do
            add_life(_ENV)
        end

        spawn_asteroids(_ENV, 7)

    end,

    update = function(_ENV)

        frames += 1
        
        if (frames > 30) then

            frames = 0

            if (not (0 == #ships)) then
                seconds_since_asteroid_spawn += 1
                seconds_since_ufo_spawn += 1
            elseif (seconds_since_game_over < 5) then
                seconds_since_game_over += 1
            end

        end

        exec_actions()
        
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

            if a:hits_player(player) then

                local msg = "p: " .. flr(player.x) .. "," .. flr(player.y) .. " : "
                msg = msg .. "a: " .. flr(a.x) .. "," .. flr(a.y) .. " " .. a.radius

                status(msg)
                
                a.is_killer = true

                lose_life(_ENV)

            end

            for b in all(bullets) do
                if (("player" == b.source) and b:hits_asteroid(a)) then
                    a:destroy()
                    b:destroy()
                    update_score(_ENV, a.score)
                end
            end

        end

        for b in all(bullets) do

            -- collisions
            if (current_ufo) then
                
                if (("ufo" == b.source) and b:hits_player(player)) then
                    lose_life(_ENV)
                elseif (("player" == b.source) and b:hits_ufo(current_ufo)) then
                    current_ufo.dead = true
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

        if (current_ufo and current_ufo:hits_player(player)) then
            current_ufo.dead = true
            current_ufo:destroy()
            lose_life(_ENV)
        end

        if ((0 == #ships) and (seconds_since_game_over > 2) and (btnp(❎) or btnp(🅾️))) then
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

        for s in all(bg.stars) do

            local draw_star = true

            if (s:behind_player(player)) then
                draw_star = false
            elseif (current_ufo and s:behind_ufo(current_ufo)) then
                draw_star = false
            else
                for a in all(asteroids) do
                    if (s:behind_asteroid(a)) then
                        draw_star = false
                        break
                    end
                end
            end

            if (draw_star) s:draw()

        end

        print("score: " .. score, 1, 1, 7)

        if (#ships == 0) then

            scprint("game over", 66, 64, 7)

            if (seconds_since_game_over > 2) then
                cprint("press any key to continue", 64, 74, blink())
            end

            if (newhighscore) then
                cprint("new high score!", 64, 20, 9)
            end

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

        camera_shake()
        
        local s = ships[#ships]

        del(ships, s)
        
        s:destroy()
        player:kill()

        if ((0 == #ships) and (score > highscore)) then
            newhighscore = true
            highscore = score
            dset(0, highscore)
        end
                
    end,

    try_spawn_player = function(_ENV, asteroids, ufo)

        -- wait two full seconds_since_asteroid_spawn
        if (not (player.frames_since_death > 60)) return

        -- after 4 seconds_since_asteroid_spawn start dropping asteroids every two seconds_since_asteroid_spawn if player hasn't spawned
        if ((player.frames_since_death > 120) and (0 == (player.frames_since_death % 60))) then
            local a = asteroids[#asteroids]
            a:destroy()
            del(asteroids, a)
        end

        -- give player a buffer in all directions
        local buffer = 20

        if (ufo) then
            if ((ufo.x > (64 - buffer) and ufo.x < (64 + buffer)) and (ufo.y > (64 - buffer) and ufo.y < (64 + buffer))) return
        end

        for a in all(asteroids) do
            if ((a.x > (64 - buffer) and a.x < (64 + buffer)) and (a.y > (64 - buffer) and a.y < (64 + buffer))) return
        end

        player:reset()

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

        local ufo_type = rnd({
            ufo,
            ufo,
            ufo_large,
            ufo_large,
            ufo_large,
            ufo_large,
            ufo_large
        })

        -- Start targeting player when they reach a score threshold 
        ufo_type:new({ target = (score > 5000) and player or nil })
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

    asteroid_spawn_count = function(_ENV)

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

        c = c or asteroid_spawn_count(_ENV)

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