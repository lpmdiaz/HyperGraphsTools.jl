module Bridges

using HyperGraphs

include("lightgraphs.jl")

# exports
if isfile(joinpath(dirname(@__FILE__), "exports.jl"))
    include("exports.jl") # some modules don't export anything
end

end # module
