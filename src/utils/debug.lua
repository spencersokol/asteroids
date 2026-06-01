log = _noop
status = _noop

function enable_debug()

    _g.status_message = ""

    log = function(any, overwrite)
        printh(tostr(any), logfile or "log", overwrite)
    end

    status = function(any)

        _g.status_message = tostr(any)

        rectfill(0, 121, 128, 128, 8)
        print(tostr(any), 1, 122, 7)
    end

    local _ad = asteroid.draw

    asteroid.draw = function(_ENV)

        if (_ENV.is_killer) then
            circfill(_ENV.x, _ENV.y, _ENV.radius - _ENV.hit_buffer, 8)
        else
            circ(_ENV.x, _ENV.y, _ENV.radius - _ENV.hit_buffer, 4)
        end

        _ad(_ENV)
        
    end

end