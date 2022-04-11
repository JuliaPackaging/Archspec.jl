using Archspec
using Documenter

DocMeta.setdocmeta!(Archspec, :DocTestSetup, :(using Archspec); recursive=true)

makedocs(;
    modules=[Archspec],
    authors="Mosè Giordano <mose@gnu.org> and contributors",
    repo="https://github.com/giordano/Archspec.jl/blob/{commit}{path}#{line}",
    sitename="Archspec.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://giordano.github.io/Archspec.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/giordano/Archspec.jl",
    devbranch="main",
)
