using HyperGraphsTools.Bridges.Catalyst
using Catalyst
using HyperGraphs

## Catalyst to HyperGraphs, and back

sir = @reaction_network SIR begin
    α, S + I --> 2I
    β, I --> R
end

@variables t
@species X(t) Y(t) Z(t)
r₁ = Reaction(2, [X], [Y])
r₂ = Reaction(1, [X, Y], [Z])
@named rsys = ReactionSystem([r₁, r₂], t, [X, Y, Z], [])

@test isequal(Reaction(ChemicalHyperEdge(r₁)), r₁)
@test isequal(Reaction(ChemicalHyperEdge(r₂)), r₂)
@test isequal(ReactionSystem(ChemicalHyperGraph(rsys)), rsys)
@test isequal(ReactionSystem(ChemicalHyperGraph(sir), name=:SIR), sir)

## HyperGraphs to Catalyst, and back

@species A(t) B(t) C(t) D(t)
e₁ = ChemicalHyperEdge([A, B], [B, C])
e₂ = ChemicalHyperEdge([B], [C, D])
x = ChemicalHyperGraph([ChemicalHyperEdge([A], [B, C]), ChemicalHyperEdge([A, B], [B, C, D])])

@test isequal(ChemicalHyperEdge(Reaction(e₁)), e₁)
@test isequal(ChemicalHyperEdge(Reaction(e₂)), e₂)
@test isequal(ChemicalHyperGraph(ReactionSystem(x)), x)