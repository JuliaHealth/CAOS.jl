# CAOS

#### Characteristic Attribute Organization System (CAOS) implementation in Julia.


| MacOS / Linux | Windows | Test Coverage | Documentation | Lifecycle |
| --- | ---- | ------ | ------ | ---- |
|[![Travis](https://img.shields.io/travis/bcbi/CAOS.jl/master.svg?style=flat-square)](https://travis-ci.org/bcbi/CAOS.jl)| [![AppVeyor](https://img.shields.io/appveyor/ci/fernandogelin/CAOS-jl/master.svg?style=flat-square)](https://ci.appveyor.com/project/fernandogelin/caos-jl) | [![Codecov](https://img.shields.io/codecov/c/github/bcbi/CAOS.jl.svg?style=flat-square)](https://codecov.io/gh/bcbi/CAOS.jl/branch/master) | [![Docs](https://img.shields.io/badge/docs-stable-blue.svg?style=flat-square)](https://bcbi.github.io/CAOS.jl/stable) [![Docs](https://img.shields.io/badge/docs-latest-blue.svg?style=flat-square)](https://bcbi.github.io/CAOS.jl/latest) | ![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg?style=flat-square) |

## Installation


### Requirements
- [BLAST][blast-url] 2.7.1+ installed and accessible in your PATH (eg. you should be able to execute `$ blastn -h` from the command line).

Install BLAST with Anaconda:

```bash
conda install blast -c bioconda
```

[blast-url]: https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download

Instal CAOS.jl

```julia
using Pkg
Pkg.clone("https://github.com/bcbi/CAOS.jl")
```

## Contributing

Contributions consistent with the style and quality of existing code are
welcome. Be sure to follow the guidelines below.

Check the issues page of this repository for available work.

### Committing


This project uses [commitizen](https://pypi.org/project/commitizen/)
to ensure that commit messages remain well-formatted and consistent
across different contributors.

Before committing for the first time, install commitizen and read
[Conventional
Commits](https://www.conventionalcommits.org/en/v1.0.0-beta.2/).

```bash
pip install commitizen
```

To start work on a new change, pull the latest `develop` and create a
new *topic branch* (e.g. feature-resume-model`,
`chore-test-update`, `bugfix-bad-bug`).

```bash
git add .
```

To commit, run the following command (instead of ``git commit``) and
follow the directions:


```bash
cz commit
```


## Project Status

The package is tested against the current Julia `1.0` and Julia `1.1` release on OS X and Linux.

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

* The function will write 7 files to the output directory: `caos_rules.json` contains all the CAOS rules for the tree, `character_labels.json` and `taxa_labels.json` contain information connecting sequences to names and locations in the tree (internal use), and the 4 `.fasta` files will be utilized later for sequence alignment using BLAST during classification.

#### Classify a sequence using CAOS rules already generated, writes the classification label to file in the output directory.
```julia
classify_new_sequence(sequence_file_path::String, output_directory::String ; all_CA_weights::Dict{Int64,Dict{String,Int64}}=Dict(1=>Dict("sPu"=>1,"sPr"=>1,"cPu"=>1,"cPr"=>1)), occurrence_weighting::Bool=false, tiebreaker::Vector{Dict{String,Int64}}=[Dict{String,Int64}()])
```

* `sequence_file_path` : The path leading to the text file containing the sequence you wish to classify. The file should only contain the characters of the sequence

* `output_directory` : The directory which contains all files pertaining to CAOS rules and classification

* `all_CA_weights` : An optional argument for the weights to be given to different types of CA's (default is all 1)

* `occurrence_weighting` : An optional argument for whether to use occurrence weighting for private rules (default is false)

* `tiebreaker` : An optional argument for whether to use a tiebreaker (next set of CA weights), or return the entire subtree

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
