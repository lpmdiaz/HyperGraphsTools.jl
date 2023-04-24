module Catalyst

using HyperGraphs
import Catalyst as _Catalyst

const Reaction = _Catalyst.Reaction
const ReactionSystem = _Catalyst.ReactionSystem

const SymType = Union{_Catalyst.Num, _Catalyst.Symbolic}

## Catalyst to HyperGraphs ##

# make a ChemicalHyperEdge from a Reaction
function HyperGraphs.ChemicalHyperEdge(r::Reaction)
    ChemicalHyperEdge(SpeciesSet(Vector(r.substrates), r.substoich), SpeciesSet(Vector(r.products), r.prodstoich), r.rate)
end

# make a ChemicalHyperGraph from a ReactionSystem
function HyperGraphs.ChemicalHyperGraph(rsys::ReactionSystem)
    eqs = _Catalyst.equations(rsys)
    neqs = length(eqs)
    nrs = sum([eq isa Reaction for eq in eqs])
    if neqs != nrs # ReactionSystems can contain both Equations and Reactions 
        rns_idx = findall(eq -> eq isa Reaction, eqs)
        eqs = eqs[rns_idx]
        @warn "$(neqs - nrs) equations dropped"
    end
    ChemicalHyperGraph(_Catalyst.states(rsys), ChemicalHyperEdge.(eqs))
end

## HyperGraphs to Catalyst ##

# make a Reaction from a ChemicalHyperEdge
function Reaction(e::ChemicalHyperEdge{T}) where {T<:SymType}
    Reaction(rate(e), src(e), tgt(e), src_stoich(e), tgt_stoich(e))
end

# make a ReactionSystem from a ChemicalHyperGraph
function ReactionSystem(x::ChemicalHyperGraph{T}; p = [], iv = first(_Catalyst.@variables t), name = :rsys) where {T<:SymType}
    isempty(p) && (any(w -> w isa SymType, weights(x)) && (p = weights(x)[findall(w -> w isa SymType, weights(x))]))
    ReactionSystem(Reaction.(hyperedges(x)), iv, vertices(x), p, name = name)
end

end # module
