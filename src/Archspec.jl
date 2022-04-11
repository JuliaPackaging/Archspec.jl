module Archspec

using Artifacts
using JSON

const archspec_json_path = joinpath(only(readdir(artifact"ArchspecJSON"; join=true)), "cpu", "microarchitectures.json")
const archspec_json = JSON.parsefile(archspec_json_path)

end
