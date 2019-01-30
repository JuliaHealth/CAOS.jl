var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#Characteristic-Attribute-Organization-System-(CAOS)-1",
    "page": "Home",
    "title": "Characteristic Attribute Organization System (CAOS)",
    "category": "section",
    "text": "This package provides an interface to use the CAOS algorithm for sequence classification.In an ideal world, a full phylogenetic analysis would be done on every new sequence found. However, this is often a time-consuming and computer-intensive task. The Characteristic Attribute Organization System (CAOS) is an algorithm to discover descriptive information about a priori organized discretized data (e.g., from a phylogenetic analysis). Derived from some of the fundamental tenets from evolutionary biology, rule sets can be generated from data sets that can be used for effecicient and effective classification of novel data elements. It\'s important to emphasize that CAOS is NOT a tree analysis, instead it is a classification scheme based on a phylogenetic analysis. Based on information (rules) discovered from the phylogenetic analysis that unambiguously distinguish between each node on a tree, CAOS is able to classify novel sequences. Studies have indicated that CAOS-based classification has over a 95% accuracy rate of classification, as determined by where sequences would be classified if a full phylogenetic analysis were to be done using the novel and known sequences.CAOS.jl is an implementation of the CAOS approach designed to approximate a parsimony-based tree analysis. This tool computes diagnostic character states from phylogenetic trees and uses them for classification of new molecular sequences.CAOS PublicationsSarkar IN, Thornton JW, Planet PJ, Figurski DH, Schierwater B, and DeSalle R. An Autotmated Phylogenetic Key for Classifying Homoboxes. Molecular Genetics and Evolution (2002) 24: 388-399.    (Image: DOI)  Sarkar IN, Planet PJ, and DeSalle R. caos software for use in character‐based DNA barcoding. Molecular Ecology Resources (2008) 8, 1256-1259.    (Image: DOI)  "
},

{
    "location": "usage/#",
    "page": "Guide",
    "title": "Guide",
    "category": "page",
    "text": ""
},

{
    "location": "usage/#Workflow-1",
    "page": "Guide",
    "title": "Workflow",
    "category": "section",
    "text": "First run the generate_caos_rules function on your tree in the required NEXUS format. This will create the necessary CAOS rules and files to use for classification.\nOnce you have generated your CAOS rules, you can load them with the function load_tree.\nLastly run the classify_new_sequence function on the sequence you wish to classify."
},

{
    "location": "usage/#NEXUS-File-Format-1",
    "page": "Guide",
    "title": "NEXUS File Format",
    "category": "section",
    "text": "In order for the parser to correctly extract all relevant information from your phylogeneitc tree, your NEXUS file must be in the exact format described below (most NEXUS files will already be in this format, but if you are having issues with your file being read properly, here is how to format it):The tree must in Newick format\nThe tree must be on a line with the words \"TREE\" and \"=\"\nThe character labels (names associated with each sequence of characters) should be directly after a line with the word \"MATRIX\" (this should be the only time the word \"MATRIX\" appears in the file)\nEach character label should be its own line, with the name followed by a number of space, and then the character sequence\nAfter your last character label, the following line should contain only a \";\"\nTaxa labels (taxa numbers for the position in the newick formatted tree associated with each character sequence name) should appear directly after a line containing the word \"TRANSLATE\" (this should be the only occurrence of that word in the file)\nEach taxa label should be its own line, with the taxa number followed by the character sequence name (at least one space in between the two)\nThe line with the last taxa label should end with a \";\""
},

{
    "location": "usage/#Examples-1",
    "page": "Guide",
    "title": "Examples",
    "category": "section",
    "text": "Two example NEXUS files are provided in the test/data folder : S10593.nex and E1E2L1.nexAn example sequence file is provided in the test/data folder : Example_Sequence.txt"
},

{
    "location": "usage/#Functions-1",
    "page": "Guide",
    "title": "Functions",
    "category": "section",
    "text": "generate_caos_rules(\"test/data/S10593.nex\", \"test/data\")This will generate your CAOS rules for the tree in the S10593.nex NEXUS file and place all output files from rule generation in the test/data directory.tree, character_labels, taxa_labels = load_tree(\"test/data\")This will load the internal representation of the tree and CAOS rules from the files output during rule generation in the test/data directory.classification = classify_new_sequence(tree, character_labels, taxa_labels, \"test/data/Example_Sequence.txt\", \"test/data\")This will return the classification result, either a string with the classification label or a Node object (under classifiction)."
},

{
    "location": "documentation/#",
    "page": "API",
    "title": "API",
    "category": "page",
    "text": "##Importusing CAOS"
},

{
    "location": "documentation/#Index-1",
    "page": "API",
    "title": "Index",
    "category": "section",
    "text": "Modules = [CAOS]"
},

{
    "location": "documentation/#CAOS.add_blanks-Tuple{String,String,Dict{String,String},Dict{String,String}}",
    "page": "API",
    "title": "CAOS.add_blanks",
    "category": "method",
    "text": "add_blanks(query_path::String, db_path::String, character_labels::Dict{String,String},\ncharacter_labels_no_gaps::Dict{String,String} ; return_blast::Bool=false)\n\nAdds blanks to an input sequence given a database.\n\nArguments\n\nquery_path::String: path to the query file.\ndb_path::String: path to the blast database.\ncharacter_labels::Dict{String,String}: a mapping of the character labels to the corresponding sequences.\ncharacter_labels_no_gaps::Dict{String,String}: character labels with gaps removed from sequences.\nreturn_blast::Bool=false: whether to return blast results.\nprotein::Bool=false: if protein sequence.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.add_nodes!-Tuple{CAOS.Node,Array{Dict{String,Any},N} where N,Array{Dict{String,Any},N} where N,Array{Dict{String,Any},N} where N,Array{Dict{String,Any},N} where N,Dict{String,String},Dict{String,String},Array{Dict{String,Any},N} where N,Int64}",
    "page": "API",
    "title": "CAOS.add_nodes!",
    "category": "method",
    "text": "add_nodes!(tree::Node,sPu::Array{Dict{String,Any}},sPr::Array{Dict{String,Any}},\ncPu::Array{Dict{String,Any}},cPr::Array{Dict{String,Any}},taxa_labels::Dict{String,String},\ncharacter_labels::Dict{String,String},nodes::Array{Dict{String,Any}},node_num::Int64;complex::Bool=true)\n\nTakes a tree (Node), adds all the CA\'s from the entire tree into the internal representation.\n\nArguments\n\ntree::Node: the tree represented as a Node.\nsPu::Array{Dict{String,Any}}: an array of simple pure rules.\nsPr::Array{Dict{String,Any}}: an array of simple private rules.\ncPu::Array{Dict{String,Any}}: an array of complex pure rules.\ncPr::Array{Dict{String,Any}}: an array of complex private rules.\ntaxa_labels::Dict{String,String}: a mapping of the taxa labels to the character labels.\ncharacter_labels::Dict{String,String}: a mapping of the character labels to the corresponding sequences.\nnodes::Array{Dict{String,Any}}: an array of nodes.\nnode_num::Int64: the current node number.\ncomplex::Bool=true: indicates whether complex rules should be calculated\nprotein::Bool=false: indicates whether dataset is a protein (or nucleotide)\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.classify_new_sequence-Tuple{CAOS.Node,Dict{String,String},Dict{String,String},String,String}",
    "page": "API",
    "title": "CAOS.classify_new_sequence",
    "category": "method",
    "text": "classify_new_sequence(tree::Node, character_labels::Dict{String,String}, taxa_labels::Dict{String,String},\nsequence_file_path::String, output_directory::String ; all_CA_weights::Dict{Int64,\nDict{String,Int64}}=Dict(1=>Dict(\"sPu\"=>1,\"sPr\"=>1,\"cPu\"=>1,\"cPr\"=>1)), occurrence_weighting::Bool=false,\ntiebreaker::Vector{Dict{String,Int64}}=[Dict{String,Int64}()], combo_classification::Bool=false)\n\nTakes a tree (Node) and a sequence, and classifies the new sequence using the CAOS tree.\n\nArguments\n\ntree::Node: the tree represented as a Node.\ncharacter_labels::Dict{String,String}: a mapping of the character labels to the corresponding sequences.\ntaxa_labels::Dict{String,String}: a mapping of the taxa labels to the character labels.\nsequence_file_path::String: a file path to the sequence to classify.\noutput_directory::String: path to the output directory.\nall_CA_weights::Dict{Int64,Dict{String,Int64}}=Dict(1=>Dict(\"sPu\"=>1,\"sPr\"=>1,\"cPu\"=>1,\"cPr\"=>1)): CA weights to be used.\noccurrence_weighting::Bool=false: whether to use occurence weighting in classification.\ntiebreaker::Vector{Dict{String,Int64}}=[Dict{String,Int64}()]: tiebreaker to be used in classification.\ncombo_classification::Bool=false: whether to use a combo of Blast and CAOS for classification.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.classify_sequence-Tuple{String,CAOS.Node,Dict{String,Int64},Dict{Int64,Dict{String,Int64}},Bool,Int64,Array{Dict{String,Int64},1}}",
    "page": "API",
    "title": "CAOS.classify_sequence",
    "category": "method",
    "text": "classify_sequence(sequence::String, tree::Node, CA_weights::Dict{String,Int64},\nall_CA_weights::Dict{Int64,Dict{String,Int64}}, occurrence_weighting::Bool,\ndepth::Int64, tiebreaker::Vector{Dict{String,Int64}} ; blast_results=[\"Fake Label\"], combo_classification::Bool=false, protein::Bool=false)\n\nClassifies an input sequence given a phylogentic tree.\n\nArguments\n\nsequence::String: sequence to count matches.\ntree::Node: the tree represented as a Node.\nCA_weights::Dict{String,Int64}: weights to use for CA counts.\nall_CA_weights::Dict{Int64,Dict{String,Int64}}: all sets of weights to use for CA counts.\noccurrence_weighting::Bool: whether to use occurrence weighting during counting.\ndepth::Int64: current depth of the tree.\ntiebreaker::Vector{Dict{String,Int64}}: tiebreaking procedures to use.\nblast_results=[\"Fake Label\"]: list of blast results.\ncombo_classification::Bool=false: whether to use both Blast and CAOS for classification.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.convert_to_struct-Tuple{Dict{String,Any},CAOS.Node}",
    "page": "API",
    "title": "CAOS.convert_to_struct",
    "category": "method",
    "text": "convert_to_struct(tree_dict::Dict{String,Any}, tree_obj::Node)\n\nTakes a tree loaded from json and convert it back to a proper internal representation.\n\nArguments\n\ntree_dict::Dict{String,Any}: tree as a dictionary after being read from json.\ntree_obj::Node: the tree (Node).\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.downsample_taxa-Tuple{Array{String,N} where N,Float64}",
    "page": "API",
    "title": "CAOS.downsample_taxa",
    "category": "method",
    "text": "downsample_taxa(taxa::Array{String}, perc_keep::Float64)\n\nDownsamples taxa by a certain percentage.\n\nArguments\n\ntaxa::Array{String}: list of taxa.\nperc_keep::Float64: percentage of taxa to keep.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.find_sequence-Tuple{CAOS.Node,String}",
    "page": "API",
    "title": "CAOS.find_sequence",
    "category": "method",
    "text": "find_sequence(tree::Node, taxa_label::String)\n\nTakes a tree (Node) and a taxa label and finds the subtree containing that sequence.\n\nArguments\n\ntree::Node: the tree represented as a Node.\ntaxa_label::String: taxa label.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.generate_caos_rules-Tuple{String,String}",
    "page": "API",
    "title": "CAOS.generate_caos_rules",
    "category": "method",
    "text": "generate_caos_rules(tree_file_path::String, output_directory::String)\n\nTakes a Nexus file and generates all the CAOS rules for the tree.\n\nArguments\n\ntree_file_path::String: path to the Nexus file.\noutput_directory::String: path to the output directory.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.get_adjusted_start-Tuple{Int64,String}",
    "page": "API",
    "title": "CAOS.get_adjusted_start",
    "category": "method",
    "text": "get_adjusted_start(original_start::Int, subject::String)\n\nAdjusts the start of the matched subject based on its blanks.\n\nArguments\n\noriginal_start::Int: the index of the original starting position.\nsubject::String: the matched subject.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.get_all_neighbors-Tuple{CAOS.Node,Dict{String,String},String}",
    "page": "API",
    "title": "CAOS.get_all_neighbors",
    "category": "method",
    "text": "get_all_neighbors(tree::Node, character_labels::Dict{String,String}, taxa_label::String)\n\nTakes a tree (Node) and a taxa label and finds all the neighbors (including duplicates).\n\nArguments\n\ntree::Node: the tree represented as a Node.\ncharacter_labels::Dict{String,String}: character label mappings.\ntaxa_label::String: taxa label.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.get_cPu_and_cPr-Tuple{Array{Dict{String,Any},N} where N,Int64,Dict{String,String},Dict{String,String},Array{Dict{String,Any},N} where N,Array{Dict{String,Any},N} where N}",
    "page": "API",
    "title": "CAOS.get_cPu_and_cPr",
    "category": "method",
    "text": "get_cPu_and_cPr(nodes::Array{Dict{String,Any}}, node_num::Int64, taxa_labels::Dict{String,String},\ncharacter_labels::Dict{String,String}, sPu::Array{Dict{String,Any}}, sPr::Array{Dict{String,Any}})\n\nGets all the cPu and cPr for the entire character sequence at a specific node (does not support nucleotide options).\n\nArguments\n\nnodes::Array{Dict{String,Any}}: list of nodes.\nnode_num::Int64: current node index.\ntaxa_labels::Dict{String,String}: a mapping of the taxa labels to the character labels.\ncharacter_labels::Dict{String,String}: a mapping of the character labels to the corresponding sequences.\nsPu::Array{Dict{String,Any}}: list of simple pure rules.\nsPr::Array{Dict{String,Any}}: list of simple private rules.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.get_descendents-Tuple{CAOS.Node}",
    "page": "API",
    "title": "CAOS.get_descendents",
    "category": "method",
    "text": "get_descendents(tree::Node)\n\nGets descendents of a Node (tree or subtree).\n\nArguments\n\ntree::Node: the tree represented as a Node.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.get_first_taxa_from_tree-Tuple{CAOS.Node}",
    "page": "API",
    "title": "CAOS.get_first_taxa_from_tree",
    "category": "method",
    "text": "get_first_taxa_from_tree(tree::Node)\n\nGets the first taxa from a tree.\n\nArguments\n\ntree::Node: the tree represented as a Node.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.get_group_combos-Tuple{Array{Array{String,N} where N,N} where N}",
    "page": "API",
    "title": "CAOS.get_group_combos",
    "category": "method",
    "text": "get_group_combos(group_taxa::Array{Array{String}})\n\nGets all the combinations of group vs non groups.\n\nArguments\n\ngroup_taxa::Array{Array{String}}: list of taxa within a group.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.get_group_taxa_at_node-Tuple{Array{Dict{String,Any},N} where N,Int64}",
    "page": "API",
    "title": "CAOS.get_group_taxa_at_node",
    "category": "method",
    "text": "get_group_taxa_at_node(nodes::Array{Dict{String,Any}}, node_num::Int64)\n\nGets the sets of taxa for each group at a node.\n\nArguments\n\nnodes::Array{Dict{String,Any}}: list of nodes.\nnode_num::Int64: current node index.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.get_max_depth-Tuple{CAOS.Node,Int64}",
    "page": "API",
    "title": "CAOS.get_max_depth",
    "category": "method",
    "text": "get_max_depth(tree::Node, depth::Int64)\n\nTakes a tree (Node) and gets the maximum depth.\n\nArguments\n\ntree::Node: the tree represented as a Node.\ndepth::Int64: current depth.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.get_neighbors-Tuple{CAOS.Node,String}",
    "page": "API",
    "title": "CAOS.get_neighbors",
    "category": "method",
    "text": "get_neighbors(tree::Node, taxa_label::String)\n\nTakes a tree (Node) and a taxa label and finds all the neighbors (taxa that come after from the subtree containing the input taxa).\n\nArguments\n\ntree::Node: the tree represented as a Node.\ntaxa_label::String: taxa label.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.get_nodes-Tuple{String}",
    "page": "API",
    "title": "CAOS.get_nodes",
    "category": "method",
    "text": "get_nodes(tree::String ; taxa_to_remove::Union{Array{String,1},Bool}=false)\n\nTakes a tree in Newick format, returns an internal representation of the tree.\n\nArguments\n\ntree::String: the tree in Newick format.\ntaxa_to_remove::Union{Array{String,1},Bool}=false: the taxa that will be removed (if applicable).\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.get_sPu_and_sPr-Tuple{Array{Dict{String,Any},N} where N,Int64,Dict{String,String},Dict{String,String}}",
    "page": "API",
    "title": "CAOS.get_sPu_and_sPr",
    "category": "method",
    "text": "get_sPu_and_sPr(nodes::Array{Dict{String,Any}}, node_num::Int64,\ntaxa_labels::Dict{String,String}, character_labels::Dict{String,String})\n\nGets all the sPu and sPr for the entire character sequence at a specific node.\n\nArguments\n\nnodes::Array{Dict{String,Any}}: list of nodes.\nnode_num::Int64: current node index.\ntaxa_labels::Dict{String,String}: a mapping of the taxa labels to the character labels.\ncharacter_labels::Dict{String,String}: a mapping of the character labels to the corresponding sequences.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.load_tree-Tuple{String}",
    "page": "API",
    "title": "CAOS.load_tree",
    "category": "method",
    "text": "load_tree(directory::String)\n\nLoads a CAOS tree from file.\n\nArguments\n\ndirectory::String: path to directory where tree exists.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.parse_tree-Tuple{String}",
    "page": "API",
    "title": "CAOS.parse_tree",
    "category": "method",
    "text": "parse_tree(file_path::String; taxa_to_remove::Union{Array{String,1},Bool}=false)\n\nTakes a Nexus file for a tree, returns an internal representation of that tree (and other relevant information).\n\nArguments\n\nfile_path::String: file path to the Nexus file.\ntaxa_to_remove::Union{Array{String,1},Bool}=false: the taxa that will be removed (if applicable).\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.remove_blanks-Tuple{Dict{String,String}}",
    "page": "API",
    "title": "CAOS.remove_blanks",
    "category": "method",
    "text": "remove_blanks(char_label_dict::Dict{String,String} ; change_to_N::Bool=false)\n\nChanges all blanks to N\'s in character sequences.\n\nArguments\n\nchar_label_dict::Dict{String,String}: character label mappings.\nchange_to_N::Bool=false: whether to change to N or just remove.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.remove_from_tree!-Tuple{Array{String,1},Union{Bool, Array{String,1}}}",
    "page": "API",
    "title": "CAOS.remove_from_tree!",
    "category": "method",
    "text": "remove_from_tree!(tree_tokens::Vector{String}, taxa_to_remove::Union{Array{String,1},Bool})\n\nTakes a tree in Newick format, removes a specific taxa from the tree.\n\nArguments\n\ntree_tokens::Vector{String}: the tree in Newick format, tokenized.\ntaxa_to_remove::Union{Array{String,1},Bool}: the taxa that will be removed.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.CA_matches-Tuple{String,Array{CAOS.Rule,1},Dict{String,Int64},Bool}",
    "page": "API",
    "title": "CAOS.CA_matches",
    "category": "method",
    "text": "CA_matches(sequence::String, CAs::Vector{Rule}, CA_weights::Dict{String,Int64}, occurrence_weighting::Bool)\n\nCounts the number of CA\'s matched by a sequence (only support for simple rules).\n\nArguments\n\nsequence::String: sequence to count matches.\nCAs::Vector{Rule}: list of all CA\'s.\nCA_weights::Dict{String,Int64}: weights to use for CA counts.\noccurrence_weighting::Bool: whether to use occurrence weighting during counting.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.add_blanks_to_back-Tuple{String,String,String,Int64,Int64,Int64,Array{String,1},Int64,Dict{String,String}}",
    "page": "API",
    "title": "CAOS.add_blanks_to_back",
    "category": "method",
    "text": "add_blanks_to_back(subject::String, query::String, new_seq::String,\nsubj_len::Int64, query_len::Int64, subj_non_blanks::Int64,\nhitnames::Vector{String}, hit_idx::Int64, character_labels::Dict{String,String})\n\nAdds blanks to the back of a sequence from a blast match.\n\nArguments\n\nsubject::String: the subject the query is being matched to.\nquery::String: the query that is having blanks added to it.\nnew_seq::String: the new sequence (query with added blanks).\nsubj_len::Int64: length of the subject.\nquery_len::Int64: length of the query.\nsubj_non_blanks::Int64: number of non blanks in the subject.\nhitnames::Vector{String}: list of blast hits.\nhit_idx::Int64: index of the current blast hit.\ncharacter_labels::Dict{String,String}: a mapping of the character labels to the corresponding sequences.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.add_blanks_to_front-Tuple{String,String,String,Int64,Int64,Int64,Array{String,1},Int64,Dict{String,String}}",
    "page": "API",
    "title": "CAOS.add_blanks_to_front",
    "category": "method",
    "text": "add_blanks_to_front(subject::String, query::String, new_seq::String,\nsubj_len::Int64, query_len::Int64, subj_non_blanks::Int64,\nhitnames::Vector{String}, hit_idx::Int64, character_labels::Dict{String,String})\n\nAdds blanks to the front of a sequence from a blast match.\n\nArguments\n\nsubject::String: the subject the query is being matched to.\nquery::String: the query that is having blanks added to it.\nnew_seq::String: the new sequence (query with added blanks).\nsubj_len::Int64: length of the subject.\nquery_len::Int64: length of the query.\nsubj_non_blanks::Int64: number of non blanks in the subject.\nhitnames::Vector{String}: list of blast hits.\nhit_idx::Int64: index of the current blast hit.\ncharacter_labels::Dict{String,String}: a mapping of the character labels to the corresponding sequences.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.get_best_hit-Tuple{Array{BioTools.BLAST.BLASTResult,1},String,Dict{String,String},Dict{String,String}}",
    "page": "API",
    "title": "CAOS.get_best_hit",
    "category": "method",
    "text": "get_best_hit(results::Array{BioTools.BLAST.BLASTResult,1}, query::String,\ncharacter_labels::Dict{String,String},  character_labels_no_gaps::Dict{String,String})\n\nGets the hit from blastn that has the most sequence coverage with no gaps compared to the query sequence.\n\nArguments\n\nresults::Array{BioTools.BLAST.BLASTResult,1}: blastn results.\nquery::String: the query that is having blanks added to it.\ncharacter_labels::Dict{String,String}: a mapping of the character labels to the corresponding sequences.\ncharacter_labels_no_gaps::Dict{String,String}: character labels with gaps removed from sequences.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.get_duplicate_labels-Tuple{Dict{String,String},String}",
    "page": "API",
    "title": "CAOS.get_duplicate_labels",
    "category": "method",
    "text": "get_duplicate_labels(character_labels::Dict{String,String}, label::String)\n\nTakes the character labels and a specific label and finds if any other sequences are the same.\n\nArguments\n\ncharacter_labels::Dict{String,String}: character label mappings.\nlabel::String: taxa label to search for duplicates of.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.get_next_hit-Tuple{Array{String,1},Int64}",
    "page": "API",
    "title": "CAOS.get_next_hit",
    "category": "method",
    "text": "get_next_hit(hitnames::Vector{String}, hit_idx::Int64)\n\nGets the next best hit returned from a blastn search.\n\nArguments\n\nhitnames::Vector{String}: a list of all blastn hitnames.\nhit_idx::Int64: index of the current hit.\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.Node",
    "page": "API",
    "title": "CAOS.Node",
    "category": "type",
    "text": "Node(CAs::Array{Rule,1}, taxa_label::String=\"\")\n\nStruct to store a node (is recursive).\n\n\n\n\n\n"
},

{
    "location": "documentation/#CAOS.Rule",
    "page": "API",
    "title": "CAOS.Rule",
    "category": "type",
    "text": "Rule(idxs::Tuple{Vararg{Int}}, char_attr::Tuple{Vararg{Char}},\nis_pure::Bool, num_group::Int, num_non_group::Int, occurances::Int)\n\nStruct to store relevant information about a CA.\n\n\n\n\n\n"
},

{
    "location": "documentation/#Functions-1",
    "page": "API",
    "title": "Functions",
    "category": "section",
    "text": "Modules = [CAOS]\nOrder   = [:function, :type]"
},

]}
