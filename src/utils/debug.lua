log = _noop

function enable_debug()

    log = function(any, overwrite)
        printh(tostr(any), logfile or "log", overwrite)
    end

    local _ad = asteroid.draw

    asteroid.draw = function(_ENV)

        if (_ENV.is_killer) then
            circfill(_ENV.x, _ENV.y, _ENV.width, 8)
        else
            circ(_ENV.x, _ENV.y, _ENV.width, 4)
        end

        _ad(_ENV)
        
    end

end