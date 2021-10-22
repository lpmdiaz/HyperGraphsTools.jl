<h1 align="center"><a>HyperGraphsTools.jl</a></h1>

This package will provide various extensions to the [HyperGraphs.jl](https://github.com/lpmdiaz/HyperGraphs.jl) package.

It is designed to function as a set of modules that can be loaded independently, or as a full package that uses all the modules it defines at the same time. The former behaviour may be accessed by running `using HyperGraphsTools.ModuleName` while the latter is given by running the usual `using HyperGraphsTools`.


Below is a description of the modules implemented. Note that each submodule (i.e. subheader of the following section) is also available as a standalone module.

## Bridges

### Graphs

Extensions of `Base.convert` are implemented to easily bridge [Graphs.jl](https://github.com/JuliaGraphs/Graphs.jl) and HyperGraphs.jl.

In the Graphs.jl to HyperGraphs.jl direction, any Graphs.jl type can be converted to the appropriate HyperGraphs.jl type (given matching orientation e.g. a directed Graphs.jl type must be converted to an oriented hypergraph).

In the HyperGraphs.jl to Graphs.jl direction, only the conversion from a HyperGraph to a SimpleGraph is currently supported; this is because information would be lost by any other conversion at this point (more conversions can be written once more hypergraph types are implemented in HyperGraphs.jl).

#### Notes

- All edges in Graphs.jl have an `src` and a `dst` field, implying a direction. This means that conversion at the edge level is not possible because there is no way to know if that edge is in a directed or undirected graph.
- Only `HyperGraph`s of type `Int` can be passed over to Graphs.jl since only integer vertices are allowed. The vertices of the input `HyperGraph` must also be consecutive.
