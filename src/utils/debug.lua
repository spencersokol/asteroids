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

    local _pd = player_ship.draw

    player_ship.draw = function(_ENV)

        _pd(_ENV)

        if (not _ENV.dead) then

            for s in all(_ENV:sides()) do
                line(s.x1, s.y1, s.x2, s.y2, 8)
            end

        end
        
    end

    local _ud = ufo.draw
    local _uld = ufo_large.draw

    ufo.draw = function(_ENV)

        _ud(_ENV)

        for s in all(_ENV:sides()) do
            line(s.x1, s.y1, s.x2, s.y2, 8)
        end

    end

    ufo_large.draw = function(_ENV)

        _uld(_ENV)

        for s in all(_ENV:sides()) do
            line(s.x1, s.y1, s.x2, s.y2, 8)
        end

    end

end