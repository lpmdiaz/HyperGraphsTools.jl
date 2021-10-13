using HyperGraphsTools.Bridges
import LightGraphs as LG
using HyperGraphs, SimpleTraits

const AbstractSimpleGraph = LG.SimpleGraphs.AbstractSimpleGraph
const AbstractSimpleEdge = LG.SimpleGraphs.AbstractSimpleEdge

# helpers that return Tuples of edge vertices for easier testing
@traitfn make_edge_tuples(x::T::IsOriented) where {T<:AbstractHyperGraph} = [(src(e)[1], tgt(e)[1]) for e in hyperedges(x)]
@traitfn make_edge_tuples(x::T::(!IsOriented)) where {T<:AbstractHyperGraph} = [Tuple(vx) for vx in vertices(hyperedges(x))]
make_edge_tuples(g::T) where {T<:AbstractSimpleGraph} = [(e.src, e.dst) for e in collect(LG.edges(g))]

# setting up some LightGraphs graphs
n = rand(1:50)
comp_u = LG.complete_graph(n)
comp_d = LG.complete_digraph(n)
path_u = LG.path_graph(n)
path_d = LG.path_digraph(n)

## LightGraphs to HyperGraphs ##

# bringing the LightGraphs types into HyperGraphs
comp_u_x = convert(HyperGraph, comp_u)
comp_d_x = convert(ChemicalHyperGraph, comp_d)
path_u_x = convert(HyperGraph, path_u)
path_d_x = convert(ChemicalHyperGraph, path_d)

@test make_edge_tuples(comp_u_x) == make_edge_tuples(comp_u)
@test make_edge_tuples(comp_d_x) == make_edge_tuples(comp_d)
@test make_edge_tuples(path_u_x) == make_edge_tuples(path_u)
@test make_edge_tuples(path_d_x) == make_edge_tuples(path_d)

# testing incorrect pairs of objects and types (because of non-matching orientation)

# convert a SimpleGraph to a ChemicalHyperGraph (oriented)
@test_throws ErrorException convert(ChemicalHyperGraph, comp_u)
@test_throws ErrorException convert(ChemicalHyperGraph, path_u)

# convert a SimpleDiGraph to a HyperGraph (unoriented)
@test_throws ErrorException convert(HyperGraph, comp_d)
@test_throws ErrorException convert(HyperGraph, path_d)

## HyperGraphs to LightGraphs ##

# example HyperGraph and its conversion to a LightGraphs.SimpleGraph
x = HyperGraph([HyperEdge([1, 2]), HyperEdge([2, 3]), HyperEdge([3, 4])])
g = convert(LG.SimpleGraph, x)

@test make_edge_tuples(x) == make_edge_tuples(g)
@test_throws ErrorException convert(LG.SimpleGraph, HyperGraph(HyperEdge([1, 1]))) # loop
@test_throws ErrorException convert(LG.SimpleGraph, HyperGraph([HyperEdge([1, 2]), HyperEdge([1, 2])])) # parallel edge
@test_throws ErrorException convert(LG.SimpleGraph, HyperGraph([HyperEdge([1, 2, 3])])) # cardinality >2
@test_throws MethodError convert(LG.SimpleGraph, HyperGraph{String}()) # type is not Int
@test_throws ErrorException convert(LG.SimpleGraph, HyperGraph([HyperEdge([1, 2]), HyperEdge([4, 5])])) # non-consecutive vertices
