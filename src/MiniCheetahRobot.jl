module MiniCheetahRobot

using RigidBodyDynamics

packagepath() = joinpath(@__DIR__, "..", "deps")
urdfpath() = joinpath(packagepath(), "cheetah_description", "mini_cheetah.urdf")

function mechanism(::Type{T} = Float64;
                   floating = true,
                   remove_fixed_tree_joints = true,
                   add_flat_ground = false) where {T}
    mechanism = RigidBodyDynamics.parse_urdf(urdfpath(); scalar_type = T,
                floating = floating, remove_fixed_tree_joints = remove_fixed_tree_joints)

    remove_fixed_tree_joints && remove_fixed_tree_joints!(mechanism)

    return mechanism
end

function __init__()
    if !isfile(urdfpath())
        error("Could not find $(urdfpath()). Please run `import Pkg; Pkg.build(\"MiniCheetahRobot\")`.")
    end
end

end # module
