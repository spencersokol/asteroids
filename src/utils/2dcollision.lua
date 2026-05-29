function point_in_circle(x, y, cx, cy, radius)

    local x_distance = x - cx
    local y_distance = y - cy
    local distance = sqrt((x_distance * x_distance) + (y_distance * y_distance))

    return (distance <= radius)
end

function line_in_circle(x1, y1, x2, y2, cx, cy, radius)
    return false
end