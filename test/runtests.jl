using Test

const tests = [
    "bridges/graphs",
]

for test in tests
    @testset "$(replace(test, "/" => ": "))" begin include("$test.jl") end
end
