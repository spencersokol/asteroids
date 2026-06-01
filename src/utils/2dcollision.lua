function point_in_circle(x, y, cx, cy, radius)

    -- transpose everything just to make
    -- sure every coord is positive
    x += 128
    y += 128
    cx += 128
    cy += 128

    local x_distance = x - cx
    local y_distance = y - cy

    -- optimization to only check close objects
    if ((abs(x_distance) > 10) or (abs(y_distance) > 10)) return false

    local distance = sqrt((x_distance * x_distance) + (y_distance * y_distance))

    return (distance <= radius)
end

function line_in_circle(x1, y1, x2, y2, cx, cy, radius)
    return false
end