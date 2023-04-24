<h1 align="center"><a>HyperGraphsTools.jl</a></h1>

This package will provide various extensions to the [HyperGraphs.jl](https://github.com/lpmdiaz/HyperGraphs.jl) package.

It is designed to function as a set of modules that can be loaded independently, or as a full package that uses all the modules it defines at the same time. The former behaviour may be accessed by running `using HyperGraphsTools.ModuleName` while the latter is given by running the usual `using HyperGraphsTools`.


Below is a description of the modules implemented. Note that each submodule (i.e. subheader of the following section) is also available as a standalone module.

## Bridges

### Catalyst

A bridge between HyperGraphs.jl and [Catalyst.jl](https://github.com/SciML/Catalyst.jl) is implemented through connections between the `ChemicalHyperEdge` and `Reaction` types, and the `ChemicalHyperGraph` and `ReactionSystem` types. This is done in each case by extending the relevant constructor to the relevant type, meaning for intance that running `ChemicalHyperEdge(r)` will return a `ChemicalHyperEdge` when `r` is a `Reaction`. Note that in the Catalyst.jl to HyperGraphs.jl direction some information is lost at the `ReactionSystem` level (the model name, for instance).

Note that this bridge extends to other packages through the connection between Catalyst.jl and ModelingToolkit.jl. This for instance includes [SBMLToolit.jl](https://github.com/SciML/SBMLToolkit.jl), as illustrated below.

```julia
using HyperGraphs
using HyperGraphsTools.Bridges.Catalyst
using SBMLToolkit

rsys = readSBML(sbmlfile, ReactionSystemImporter())
ChemicalHyperGraph(rsys)
```


### Graphs

Extensions of `Base.convert` are implemented to easily bridge [Graphs.jl](https://github.com/JuliaGraphs/Graphs.jl) and HyperGraphs.jl.

In the Graphs.jl to HyperGraphs.jl direction, any Graphs.jl type can be converted to the appropriate HyperGraphs.jl type (given matching orientation e.g. a directed Graphs.jl type must be converted to an oriented hypergraph).

In the HyperGraphs.jl to Graphs.jl direction, only the conversion from a HyperGraph to a SimpleGraph is currently supported; this is because information would be lost by any other conversion at this point (more conversions can be written once more hypergraph types are implemented in HyperGraphs.jl).

#### Notes

- All edges in Graphs.jl have an `src` and a `dst` field, implying a direction. This means that conversion at the edge level is not possible because there is no way to know if that edge is in a directed or undirected graph.
- Only `HyperGraph`s of type `Int` can be passed over to Graphs.jl since only integer vertices are allowed. The vertices of the input `HyperGraph` must also be consecutive.
