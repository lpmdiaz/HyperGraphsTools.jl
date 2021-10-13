using Test

const tests = [
    "bridges/lightgraphs",
]

for test in tests
    @testset "$(replace(test, "/" => ": "))" begin include("$test.jl") end
end
