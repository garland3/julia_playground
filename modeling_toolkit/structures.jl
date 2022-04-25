"Basic point"
struct  Point{T}
    x::T
    y::T
end


function Point(loc::String)
    if lowercase(loc) == "home"
         return Point(0,0)
 
    else
         println("unknown location $loc")
    end 
 end

struct LargePoint <: Point
    size::Float64
end

# function LargePoint(p::Point, size::Float64)

# end



p = Point(1,2)
println(p)

p = Point("Home")
println(p)