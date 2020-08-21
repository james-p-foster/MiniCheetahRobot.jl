using Test
using MiniCheetahRobot
using RigidBodyDynamics

@testset "MiniCheetahRobot" begin
    mechanism = MiniCheetahRobot.mechanism()
    @test num_velocities(mechanism) == 21
    meshdir = joinpath(MiniCheetahRobot.packagepath(), "cheetah_description", "meshes")
    @test isdir(meshdir)
    @test count(x -> endswith(x, ".obj"), readdir(meshdir)) == 4
end
