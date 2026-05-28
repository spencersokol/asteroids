gamestate = gameobject:extend({

    bullet_count = 0,
    bullet_max = 3,
    lives = 3,
    score = 0,

    destroy = function(_ENV)

        bullet_count = 0
        bullet_max = 3
        lives = 3
        score = 0

    end

})