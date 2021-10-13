module HyperGraphsTools

using HyperGraphs

pkgmodules = ["Bridges"]

for pkgmodule in pkgmodules
    lcpkgmodule = lowercase(pkgmodule)
    include("$lcpkgmodule/$lcpkgmodule.jl")
	if isfile(joinpath(dirname(@__FILE__), lcpkgmodule, "exports.jl"))
		include("$lcpkgmodule/exports.jl") # some modules don't export anything
	end
	eval(Meta.parse("using .$(Symbol(pkgmodule))"))
end

end # module
