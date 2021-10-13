import LightGraphs as LG

const AbstractSimpleGraph = LG.SimpleGraphs.AbstractSimpleGraph
const AbstractSimpleEdge = LG.SimpleGraphs.AbstractSimpleEdge

## LightGraphs to HyperGraphs ##

function Base.convert(::Type{T}, g::U) where {T<:AbstractHyperGraph, U<:AbstractSimpleGraph}
    ex = collect(LG.edges(g))
    etype = HyperGraphs.get_hyperedge_type(T)
    if LG.is_directed(g) && isoriented(T)
        T([etype([e.src], [e.dst]) for e in ex])
    elseif !LG.is_directed(g) && !isoriented(T)
        T([etype([e.src, e.dst]) for e in ex])
    else
        error("orientation of types does not match")
    end
end

## HyperGraphs to LightGraphs ##

# convert a HyperGraph to a LightGraphs.SimpleGraph
function Base.convert(::Type{LG.SimpleGraph}, x::HyperGraph{T}) where {T<:Int}
    !issimple(x) && error("hypergraph is not simple")
    !isgraph(x) && error("some cardinalities != 2")
    !isequal(collect(1:maximum(vertices(x))), vertices(x)) && error("non-consecutive vertices")
    LG.SimpleGraph([map((v1, v2) -> LG.Edge(v1 => v2), vertices(e)...) for e in hyperedges(x)])
end
