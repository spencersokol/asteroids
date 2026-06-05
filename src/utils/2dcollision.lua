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

function line_in_circle(line, cx, cy, radius)
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

function line_in_line(line1, line2)

    local ua = ((line2.x2 - line2.x1) * (line1.y1 - line2.y1) - (line2.y2 - line2.y1) * (line1.x1 - line2.x1)) /
        ((line2.y2 - line2.y1) * (line1.x2 - line1.x1) - (line2.x2 - line2.x1) * (line1.y2 - line1.y1))
    local ub = ((line1.x2 - line1.x1) * (line1.y1 - line2.y1) - (line1.y2 - line1.y1) * (line1.x1 - line2.x1)) /
        ((line2.y2 - line2.y1) * (line1.x2 - line1.x1) - (line2.x2 - line2.x1) * (line1.y2 - line1.y1))

    return ((ua >= 0) and (ua <= 1) and (ub >= 0) and (ub <= 1))

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

function line_in_polygon(line, sides)

    for s in all(sides) do
        local hit = line_in_line(line, s)
        if (hit) return true
    end

    return false

end

function polygon_in_polygon(sides1, sides2)

    -- polygon is inside the other
    local collision = point_in_polygon(sides2[1].x1, sides2[1].y1, sides1)
    if (collision) return true
    
    for s in all(sides1) do

        collision = line_in_polygon(s, sides2)
        if (collision) return true

    end

    return false

end