module CAOS

using Bio.Tools.BLAST
using Bio.Seq
using JSON
using FastaIO
using Tokenize

export generate_caos_rules, classify_new_sequence, load_tree

include("caos_functions.jl")
include("tree_functions.jl")
include("utils.jl")
include("classification.jl")
include("gap_imputation.jl")
include("user_functions.jl")

end # module
