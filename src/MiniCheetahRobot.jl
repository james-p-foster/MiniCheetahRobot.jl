module MiniCheetahRobot

using RigidBodyDynamics
using RigidBodyDynamics.Contact

packagepath() = joinpath(@__DIR__, "..", "deps")
urdfpath() = joinpath(packagepath(), "cheetah_description", "mini_cheetah.urdf")

function default_contact_model()
    SoftContactModel(hunt_crossley_hertz(k = 500e3), ViscoelasticCoulombModel(0.8, 20e3, 100.))
end

function mechanism(::Type{T} = Float64;
                   floating = true,
                   contactmodel = default_contact_model(),
                   remove_fixed_tree_joints = false,
                   add_flat_ground = false) where {T}
    mechanism = RigidBodyDynamics.parse_urdf(urdfpath(); scalar_type = T,
                floating = floating, remove_fixed_tree_joints = remove_fixed_tree_joints)

    if contactmodel != nothing
        for leg in (:FR, :FL, :RR, :RL)
            foot = findbody(mechanism, "$(string(leg))_foot")
            frame = default_frame(foot)
            radius = 0.015

            # bottom of foot -- in foot frame, positive x
            add_contact_point!(foot, ContactPoint(Point3D(frame, radius, 0, 0), contactmodel))
            # front of foot -- in foot frame, negative y
            add_contact_point!(foot, ContactPoint(Point3D(frame, 0, -radius, 0), contactmodel))
            # back of foot -- in foot frame, positive y
            add_contact_point!(foot, ContactPoint(Point3D(frame, 0,  radius, 0), contactmodel))
            # left of foot -- in foot frame, positive z
            add_contact_point!(foot, ContactPoint(Point3D(frame, 0, 0,  radius), contactmodel))
            # right of foot -- in foot frame, negative z
            add_contact_point!(foot, ContactPoint(Point3D(frame, 0, 0, -radius), contactmodel))
        end
    end

    if add_flat_ground
        frame = root_frame(mechanism)
        ground = HalfSpace3D(Point3D(frame, 0., 0., 0.), FreeVector3D(frame, 0., 0., 1.))
        add_environment_primitive!(mechanism, ground)
    end

    remove_fixed_tree_joints && remove_fixed_tree_joints!(mechanism)

    return mechanism
end

function setnominal!(cheetah_state::MechanismState)
    mechanism = cheetah_state.mechanism
    zero!(cheetah_state)

    # Give the legs there natural bend
    hip_pitch = -0.8
    knee_pitch = -1.5
    for leg in (:FR, :FL, :RR, :RL)
        hip = findjoint(mechanism, "$(string(leg))_thigh_joint")
        knee = findjoint(mechanism, "$(string(leg))_calf_joint")
        set_configuration!(cheetah_state, hip, hip_pitch)
        set_configuration!(cheetah_state, knee, knee_pitch)
    end

    # Lift the floating base joint 0.30 off the ground
    floating_joint = first(out_joints(root_body(mechanism), mechanism))
    set_configuration!(cheetah_state, floating_joint, [1; 0; 0; 0; 0; 0; 0.30])
    return cheetah_state
end

function __init__()
    if !isfile(urdfpath())
        error("Could not find $(urdfpath()). Please run `import Pkg; Pkg.build(\"MiniCheetahRobot\")`.")
    end
end

end # module
