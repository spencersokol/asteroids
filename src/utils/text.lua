_g.blink_counter = 1

function cprint(txt, x, y, c)
    print(txt, x - #tostr(txt) * 2, y, c)
end

function blink()

    local pattern = {5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,7,7,6,6,6,6,5}

    _g.blink_counter += 1

    if (_g.blink_counter > #pattern) _g.blink_counter = 1

    return pattern[_g.blink_counter]
end