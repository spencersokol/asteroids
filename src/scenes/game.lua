game = scene:extend({

    player = {},
    state = {},
    ships = {},

    init = function(_ENV)

        starfield:new()

        state = gamestate:new()
        player = player_ship:new()

        for i = 1, state.lives do
            local s = ship:new({ x = (128 - (i * 6)), y = 6 })
            log("life ship: " .. s.x .. "," .. s.y)
            add(ships, s)
        end

    end,

    update = function(_ENV)

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

        log("--- game stats ---")
        log("asteroids: " .. #asteroids)
        log("bullets: (" .. #bullets .. "/" .. state.bullet_count .. ") of " .. state.bullet_max)
        log("---")

        -- check collisions
        for a in all(asteroids) do

            if asteroid_hits_player(_ENV, a) then

                log("player died!")
                log("player: " .. player.x .. "," .. player.y)
                log("asteroid: " .. a.x .. "," .. a.y .. " " .. a.width)
                a.is_killer = true

                --do lose life or game over
                local s = ships[state.lives]
                del(ships, s)
                s:destroy()
                state.player_dead = true
                state.lives -= 1
                sfx(0)
            end

            for b in all(bullets) do
                if bullet_hits_asteroid(_ENV, b, a) then
                    log("bullet hit asteroid")
                    a:destroy(_ENV)
                    b:destroy(_ENV)
                    player.bullet_count -= 1
                    state.score += a.score
                end
            end
        end

        -- bullets should only travel so far
        for b in all(bullets) do
            
            if (b.distance > 130) then
                player.bullet_count -= 1
                b:destroy(_ENV)
            end

        end

        state:update()

        if btnp(5) then
            scene:load(title)
        end

    end,

    draw = function(_ENV)
        cls()

        -- decide on what objects to actually draw first
        -- this just tries to draw everything
        for e in all(entity.objects) do
            if (e:is(player_ship)) then
                if (not state.player_dead) e:draw()
            else
                e:draw()
            end
        end

        print("score: " .. state.score, 1, 1, 7)

    end,

    destroy = function(_ENV)
        scene.destroy(_ENV)
        state:destroy()
    end,

    bullet_hits_asteroid = function(_ENV, b, a)
        -- use point/circle collision detection

        log("--- check bullet collision ---")
        log("bullet: " .. b.x .. "," .. b.y)
        log("asteroid: " .. a.x .. "," .. a.y .. " " .. a.width)
        log("---")

        return point_in_circle(b.x, b.y, a.x, a.y, a.width)
    end,

    asteroid_hits_player = function(_ENV, a)

        if (state.player_dead) return false

        -- add a buffer here to be a little forgiving
        local radius = asteroid.width - 0.5

        log("--- check player collision ---")
        log("player front: " .. player.front.x .. "," .. player.front.y)
        log("player rear left: " .. player.rear_left.x .. "," .. player.rear_left.y)
        log("player rear right: " .. player.rear_right.x .. "," .. player.rear_right.y)
        log("asteroid: " .. a.x .. "," .. a.y .. " " .. radius)
        log("---")

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
            asteroid.x,
            asteroid.y,
            radius
        )
        local side2 = line_in_circle(
            player.front.x,
            player.front.y,
            player.rear_right.x,
            player.rear_right.y,
            asteroid.x,
            asteroid.y,
            radius
        )
        local side3 = line_in_circle(
            player.rear_left.x,
            player.rear_left.y,
            player.rear_right.x,
            player.rear_right.y,
            asteroid.x,
            asteroid.y,
            radius
        )
        
        if (side1 or side2 or side3) return true
        ]]

        return false

    end

})