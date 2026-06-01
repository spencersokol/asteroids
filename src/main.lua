if (debug) enable_debug()

function _update()
    if (scene.current) scene.current:update()
end

function _draw()
    if (scene.current) scene.current:draw()

    if (debug) then
        if (#_g.status_message > 0) status(_g.status_message)
        print(#entity.objects, 128 - (#tostr(#entity.objects) * 4), 122, 7)
    end

end