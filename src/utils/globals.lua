-- store global environment
_g = _ENV

-- debug
debug = false

highscore = 0

-- empty function
_noop = function() end

function cprint(txt, x, y, c)
    print(txt, x - (#tostr(txt) * 2), y, c)
end