module CAOS

using BioTools
using BioSequences
using JSON
using FastaIO
using Tokenize

export generate_caos_rules,
       classify_new_sequence,
       parse_tree,
       load_tree,
       get_nodes,
       remove_from_tree!

include("caos_functions.jl")
include("tree_functions.jl")
include("utils.jl")
include("classification.jl")
include("gap_imputation.jl")
include("user_functions.jl")

end # module
