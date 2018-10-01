module CAOS

using BioTools
using BioTools.BLAST
using BioSequences
using JSON
using FastaIO
using Tokenize

export generate_caos_rules,
       classify_new_sequence,
       parse_tree,
       load_tree,
       get_nodes,
       remove_from_tree!,
       remove_blanks,
       get_max_depth,
       find_sequence

include("caos_functions.jl")
include("tree_functions.jl")
include("utils.jl")
include("classification.jl")
include("gap_imputation.jl")
include("user_functions.jl")

end # module
