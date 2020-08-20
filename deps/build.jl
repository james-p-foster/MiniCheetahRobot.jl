# Below url is pinned to a specific commit -- if xiaoliangstd updates the repo
# with changes, you may want to investigate them.
mini_cheetah_url = "https://raw.githubusercontent.com/xiaoliangstd/MiniCheetah_description/f8e30e3d9f1077d096483010ddfbaa16e928a37c/cheetah_description/"

urdf_path = "xacro/mini_cheetah.urdf"

mesh_paths = [
    "meshes/mini_body.obj";
    "meshes/mini_abad.obj";
    "meshes/mini_upper_link.obj";
    "meshes/mini_lower_link.obj"
    ]

data_dir = "mini_cheetah"
ispath(data_dir) || mkpath(data_dir)
download(mini_cheetah_url * urdf_path, joinpath(data_dir, "mini_cheetah.urdf"))

for mesh_path in mesh_paths
    mesh_dir, mesh_filename = splitdir(mesh_path)
    mesh_dir = joinpath(data_dir, mesh_dir)
    ispath(mesh_dir) || mkpath(mesh_dir)
    download(mini_cheetah_url * mesh_path, joinpath(data_dir, mesh_path))
end
