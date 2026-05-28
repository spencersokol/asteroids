entity = gameobject:extend({
    label = "entity",

    -- static
    objects = {},

    -- position
    x=0,
    y=0,
    speed = 1,

    extend = function(_ENV, tbl)
        tbl = class.extend(_ENV, tbl)
        tbl.objects = {}
        return tbl
    end,

    -- instance methods
    init = function(_ENV)
        add(entity.objects ,_ENV)
        if objects != entity.objects then
            add(objects, _ENV)
        end
    end,

    update = function(_ENV)

    end,

    draw = function(_ENV)

    end,

    destroy = function(_ENV)
        del(entity.objects, _ENV)
        if objects != entity.objects then
            del(objects, _ENV)
        end
    end,

})
