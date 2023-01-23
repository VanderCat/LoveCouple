function math.clamp(min, max, ...)
    return math.max(min, math.min(max, ...))
end

function math.lerp(a, b, t)
    return a+(b-a)*t
end