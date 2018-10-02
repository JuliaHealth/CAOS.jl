using Documenter, CAOS, HTTP, JSON
# using Literate

# compile all examples in BioMedQuery/examples/literate_src into markdown and jupyter notebooks for documentation
# for (root, dirs, files) in walkdir("examples/literate_src")
#     for file in files
#         Literate.notebook(joinpath(root,file), joinpath(@__DIR__, "src", "notebooks"))
#     end
# end
#
# for (root, dirs, files) in walkdir("examples/literate_src")
#     for file in files
#         Literate.markdown(joinpath(root,file), joinpath(@__DIR__, "src", "examples"))
#     end
# end
makedocs()

logo = HTTP.request("GET", "https://gist.githubusercontent.com/fernandogelin/dc1c8bb7e26b10fe0a402d6c76008dd0/raw/83d70068a9a5145bf0b749bc7c3da79a40cb09e9/bcbi-logo.svg")

open("build/assets/bcbi-logo.svg", "w") do f
    JSON.print(f, String(logo.body))
end

deploydocs(
    deps   = Deps.pip("mkdocs==0.17.5", "mkdocs-material==2.9.4"),
    repo = "github.com/bcbi/CAOS.jl.git",
    julia  = "0.7",
    osname = "linux"
)
