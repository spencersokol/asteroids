game = scene:extend({

    player = {},
    game = {},

    init = function(_ENV)

        game = gamestate:new()
        player = ship:new()

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

        -- check collisions
        for a in all(asteroids) do

            if asteroid_hits_player(_ENV, a) then

                log("player died!")
                log("player: " .. player.x .. "," .. player.y)
                log("asteroid: " .. a.x .. "," .. a.y .. " " .. a.width)
                a.is_killer = true

                --do lose life or game over
                game.player_dead = true
                sfx(0)
            end

            for b in all(bullets) do
                if bullet_hits_asteroid(_ENV, b, a) then
                    a:destroy(_ENV)
                    b:destroy(_ENV)
                    game.score += a.score
                end
            end
        end

        -- bullets should only travel so far
        for b in all(bullets) do
            
            if (b.distance > 130) then
                b:destroy(_ENV)
            end

        end

        game:update()

        if btnp(5) then
            scene:load(title)
        end
    end,

    draw = function(_ENV)
        cls()

        -- decide on what objects to actually draw first
        -- this just tries to draw everything
        for e in all(entity.objects) do
            if (e:is(ship)) then
                if (not game.player_dead) e:draw()
            else
                e:draw()
            end
        end

        print("score: " .. game.score, 1, 1, 7)

    end,

    destroy = function(_ENV)
        game:destroy()
    end,

    bullet_hits_asteroid = function(_ENV, bullet, asteroid)
        -- use point/circle collision detection
        return point_in_circle(bullet.x, bullet.y, asteroid.x, asteroid.y, asteroid.width)
    end,

    asteroid_hits_player = function(_ENV, asteroid)

        if (game.player_dead) return false

        -- add a buffer here to be a little forgiving
        local radius = asteroid.width - 0.5

        -- check the points first
        local front = point_in_circle(player.front.x, player.front.y, asteroid.x, asteroid.y, radius)
        local rear_left = point_in_circle(player.rear_left.x, player.rear_left.y, asteroid.x, asteroid.y, radius)
        local rear_right = point_in_circle(player.rear_right.x, player.rear_right.y, asteroid.x, asteroid.y, radius)

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