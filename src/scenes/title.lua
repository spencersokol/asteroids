title = scene:extend({
    init = function(_ENV)
    end,

    update = function(_ENV)
        if btnp(5) then 
            scene:load(game)
        end
    end,

    draw = function(_ENV)
        cls()
        print('Asteroids Clone', 35, 60)
    end
})