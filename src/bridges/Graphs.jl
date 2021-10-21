module Graphs

using HyperGraphs
import Graphs as _Graphs

const AbstractSimpleGraph = _Graphs.SimpleGraphs.AbstractSimpleGraph
const AbstractSimpleEdge = _Graphs.SimpleGraphs.AbstractSimpleEdge

## LightGraphs to HyperGraphs ##

function Base.convert(::Type{T}, g::U) where {T<:AbstractHyperGraph, U<:AbstractSimpleGraph}
    ex = collect(_Graphs.edges(g))
    etype = HyperGraphs.get_hyperedge_type(T)
    if _Graphs.is_directed(g) && isoriented(T)
        T([etype([e.src], [e.dst]) for e in ex])
    elseif !_Graphs.is_directed(g) && !isoriented(T)
        T([etype([e.src, e.dst]) for e in ex])
    else
        error("orientation of types does not match")
    end
end

## HyperGraphs to LightGraphs ##

# convert a HyperGraph to a LightGraphs.SimpleGraph
function Base.convert(::Type{_Graphs.SimpleGraph}, x::HyperGraph{T}) where {T<:Int}
    !issimple(x) && error("hypergraph is not simple")
    !isgraph(x) && error("some cardinalities != 2")
    !isequal(collect(1:maximum(vertices(x))), vertices(x)) && error("non-consecutive vertices")
    _Graphs.SimpleGraph([map((v1, v2) -> _Graphs.Edge(v1 => v2), vertices(e)...) for e in hyperedges(x)])
end

end # module
