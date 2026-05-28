scene = gameobject:extend({
    load = function(_ENV, scene_class)
        if (current) current:destroy()
        current = scene_class:new()
    end,

    destroy = function(_ENV)
        camera()
        for e in all(entity.objects) do
            e:destroy()
        end
    end
})
