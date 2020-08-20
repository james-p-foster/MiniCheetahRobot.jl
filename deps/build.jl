# Below url is pinned to a specific commit -- if xiaoliangstd updates the repo
# with changes, you may want to investigate them.
mini_cheetah_url = "https://raw.githubusercontent.com/xiaoliangstd/MiniCheetah_description/f8e30e3d9f1077d096483010ddfbaa16e928a37c/cheetah_description/"

urdfpath = "xacro/mini_cheetah.urdf"

meshpaths = [
    "meshes/mini_body.obj";
    "meshes/mini_abad.obj";
    "meshes/mini_upper_link.obj";
    "meshes/mini_lower_link.obj"
    ]

datadir = "cheetah_description"
ispath(datadir) || mkpath(datadir)
download(mini_cheetah_url * urdfpath, joinpath(datadir, "mini_cheetah.urdf"))

for meshpath in meshpaths
    meshdir, meshfilename = splitdir(meshpath)
    meshdir = joinpath(datadir, meshdir)
    ispath(meshdir) || mkpath(meshdir)
    download(mini_cheetah_url * meshpath, joinpath(datadir, meshpath))
end
