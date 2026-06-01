if (debug) enable_debug()

function _update()
    if (scene.current) scene.current:update()
end

function _draw()
    if (scene.current) scene.current:draw()

    if (debug) print("entities: " .. #entity.objects, 1, 120, 7)
end