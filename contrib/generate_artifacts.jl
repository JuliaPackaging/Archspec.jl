# To update the `Artifacts.toml` in the top-level directory of the repository, change the URL as needed and simply execute this script with
#
#   julia --project=/path/to/this/directory /path/to/this/directory/generate_artifacts.jl
#
# If you are already in this directory you can simply run
#
#   julia --project=. generate_artifacts.jl

using ArtifactUtils

add_artifact!(
    joinpath(dirname(@__DIR__), "Artifacts.toml"),
    "ArchspecJSON",
    "https://github.com/archspec/archspec-json/archive/refs/tags/v0.1.3.tar.gz";
    force=true,
)
