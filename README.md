# CAOS

[![Build Status](https://travis-ci.org/paulstey/CAOS.jl.svg?branch=master)](https://travis-ci.org/paulstey/CAOS.jl)

[![Coverage Status](https://coveralls.io/repos/paulstey/CAOS.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/paulstey/CAOS.jl?branch=master)

[![codecov.io](http://codecov.io/github/paulstey/CAOS.jl/coverage.svg?branch=master)](http://codecov.io/github/paulstey/CAOS.jl?branch=master)


# CAOS

*Package for using the CAOS algorithm in Julia*

## Installation

In addition to the required Julia packages, it is required that you have [BLAST][blast-url] 2.7.1+ installed and accessible in your PATH (eg. you should be able to execute `$ blastn -h` from the command line).

[blast-url]: https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download

The package must be downloaded from GitHub

* Git: `git clone https://github.com/bcbi/CAOS`

## Project Status

The package is tested against the current Julia `0.6.1` release on OS X.

## Contributing and Questions

Contributions are very welcome, as are feature requests and suggestions. Please open an
[issue][issues-url] if you encounter any problems or would just like to ask a question.

[issues-url]: https://github.com/bcbi/CAOS/issues

## Documentation

The two functions provided by this package are located in the `user_functions.jl` file. This file also leverages helper functions from the files: `caos_functions.jl`, `tree_functions.jl` ,` utils.jl`, `classification.jl`, `gap_imputation.jl`.

To use this package to classify a sequence, first run the `generate_caos_rules` function on your tree in the required NEXUS format. This will create the necessary CAOS rules and files to use for classification. Once you have generated CAOS rules, run the `classify_new_sequence` function on the sequence you wish to classify. The resulting classification will be written to file in your defined output directory.

#### Generate CAOS rules from a phylogenetic tree, writes CAOS rule files to the output directory.
```julia
generate_caos_rules(tree_file_path::String, output_directory::String)
```

* `tree_file_path` : The path leading to the NEXUS file containing the phylogentic tree to be used to create CAOS rules. The exact format of the NEXUS file is described below.

* `output_directory` : The directory which will contain all files pertaining to CAOS rules and classification

* The function returns the tree with all CAOS rules as a Node object, as well as the character and taxa label dictionaries. It will also write 7 files to the output directory: `caos_rules.json` contains all the CAOS rules for the tree, `character_labels.json` and `taxa_labels.json` contain information connecting sequences to names and locations in the tree (internal use), and the 4 `.fasta` files will be utilized later for sequence alignment using BLAST during classification.

#### Classify a sequence using CAOS rules already generated, writes the classification label to file in the output directory.
```julia
classify_new_sequence(tree::Node, character_labels::Dict{String,String}, taxa_labels::Dict{String,String}, sequence_file_path::String, output_directory::String ; all_CA_weights::Dict{Int64,Dict{String,Int64}}=Dict(1=>Dict("sPu"=>1,"sPr"=>1,"cPu"=>1,"cPr"=>1)), occurrence_weighting::Bool=false, tiebreaker::Vector{Dict{String,Int64}}=[Dict{String,Int64}()])
```

* `tree` : A node object containing the tree with all CAOS rules

* `character_labels` : A dictionary containing the character labels with the associated sequences

* `taxa_labels` : A dictionary containing the taxa labels with the associated sequence names

* `sequence_file_path` : The path leading to the text file containing the sequence you wish to classify. The file should only contain the characters of the sequence

* `output_directory` : The directory which contains all files pertaining to CAOS rules and classification

* `all_CA_weights` : An optional argument for the weights to be given to different types of CA's (default is all 1)

* `occurrence_weighting` : An optional argument for whether to use occurrence weighting for private rules (default is false)

* `tiebreaker` : An optional argument for whether to use a tiebreaker (next set of CA weights), or return the entire subtree

* This functions returns the classification result. Either a string with the classification label or a Node object (under classifiction) will be returned.

#### Function to read tree information from file
```julia
load_tree(directory::String)
```

* `directory` : The directory where the CAOS rules and character and taxa labels are saved

* The function returns the tree with all CAOS rules as a Node object, as well as the character and taxa label dictionaries.

## NEXUS File Format

In order for the parser to correctly extract all relevant information from your phylogeneitc tree, your NEXUS file must be in the exact format described below (most NEXUS files will already be in this format, but if you are having issues with your file being read properly, here is how to format it):

* The tree must in Newick format (only parentheses, commas, and numbers)
* The tree must be on a line with the words "TREE" and "=", and only contain parentheses as part of the Newick representation
* The character labels (names associated with each sequence of characters) should be exactly 3 lines beneath a line with the word "MATRIX" (this should be the only time the word "MATRIX" appears in the file)
* Each character label should be its own line, with the name followed by a number of space, and then the character sequence
* After your last character label, the following line should contain only a ";"
* Taxa labels (taxa numbers for the position in the newick formatted tree associated with each character sequence name) should appear directly after a line containing the word "TRANSLATE" (this should be the only occurrence of that word in the file)
* Each taxa label should be its own line, with the taxa number followed by the character sequence name (at least one space in between the two)
* The line with the last taxa label should end with a ";"

An example NEXUS file is provided in the repository : `S10593.nex`

An example sequence file is provided in the repository : `Example_Sequence.txt`
