module ODEsTests

using Test

@time @testset "ODETools" begin include("ODEToolsTests/runtests.jl") end

@time @testset "TransientFETools" begin include("TransientFEToolsTests/runtests.jl") end

# @time @testset "DiffEqsWrappers" begin include("DiffEqsWrappersTests/runtests.jl") end

# include("../bench/runbenchs.jl")

end #module
