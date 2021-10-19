module Bridges

using Reexport
using HyperGraphs

pkgmodules = ["LightGraphs"]

for pkgmodule in pkgmodules
    include("$pkgmodule.jl")
	eval(Meta.parse("@reexport using .$(Symbol(pkgmodule))"))
end

end # module
