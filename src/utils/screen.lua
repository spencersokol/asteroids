
function camera_shake(frames, intensity)

    frames = frames or 12
    intensity = intensity or 3

    async(function()
        async_camera_shake(frames, intensity)
    end)

end

function async_camera_shake(frames, intensity)

    local cx = peek2(0x5f28)
    local cy = peek2(0x5f2a)

    for i = 1, frames do

        local dx = rnd(intensity) - intensity / 2
        local dy = rnd(intensity) - intensity / 2

        camera(cx + dx, cy + dy)

        yield()

    end

    camera(cx, cy)

end
