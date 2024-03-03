using Documenter
using EltypeExtensions

makedocs(
    sitename = "EltypeExtensions",
    format = Documenter.HTML(),
    modules = [EltypeExtensions]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/putianyi889/EltypeExtensions.jl.git"
)
