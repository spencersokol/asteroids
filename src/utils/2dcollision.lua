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

function point_in_rectangle(x, y, x1, y1, x2, y2)

    -- transpose everything just to make
    -- sure every coord is positive
    x += 128
    y += 128
    x1 += 128
    y1 += 128
    x2 += 128
    y2 += 128

    return ((x >= x1) and (y >= y1) and (x <= x2) and (y <= y2))
end

function point_in_polygon(x, y, sides)
    
    local collision = false

    for side in all(sides) do
        if (((side.y1 >= y and side.y2 < y) or (side.y1 < y and side.y2 >= y)) and
            (x < (side.x2 - side.x1) * (y - side.y1) / (side.y2 - side.y1) + side.x1)) then
                collision = not collision
        end
    end

    return collision

end