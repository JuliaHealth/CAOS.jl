# Characteristic Attribute Organization System (CAOS)

This package provides an interface to use the CAOS algorithm for sequence classification.

In an ideal world, a full phylogenetic analysis would be done on every new sequence found. However, this is often a time-consuming and computer-intensive task. The Characteristic Attribute Organization System (CAOS) is an algorithm to discover descriptive information about *a priori* organized discretized data (*e.g.*, from a phylogenetic analysis). Derived from some of the fundamental tenets from evolutionary biology, rule sets can be generated from data sets that can be used for effecicient and effective classification of novel data elements. It's important to emphasize that CAOS is NOT a tree analysis, instead it is a classification scheme based on a phylogenetic analysis. Based on information (rules) discovered from the phylogenetic analysis that unambiguously distinguish between each node on a tree, CAOS is able to classify novel sequences. Studies have indicated that CAOS-based classification has over a 95% accuracy rate of classification, as determined by where sequences would be classified if a full phylogenetic analysis were to be done using the novel and known sequences.

CAOS.jl is an implementation of the CAOS approach designed to approximate a parsimony-based tree analysis. This tool computes diagnostic character states from phylogenetic trees and uses them for classification of new molecular sequences.

> ##### CAOS Publications  
> Sarkar IN, Thornton JW, Planet PJ, Figurski DH, Schierwater B, and DeSalle R. *An Autotmated Phylogenetic Key for Classifying Homoboxes.* Molecular Genetics and Evolution (2002) 24: 388-399.   
> [![DOI](https://img.shields.io/badge/DOI-10.1016%2FS1055--7903%2802%2900259--2-purple.svg?style=flat-square)](https://doi.org/10.1016/S1055-7903%2802%2900259-2)  
>
> Sarkar IN, Planet PJ, and DeSalle R. *caos software for use in character‐based DNA barcoding*. Molecular Ecology Resources (2008) 8, 1256-1259.   
> [![DOI](https://img.shields.io/badge/DOI-10.1111%2Fj.1755--0998.2008.02235.x-purple.svg?style=flat-square)](https://doi.org/10.1111/j.1755-0998.2008.02235.x)  


## Workflow

* First run the `generate_caos_rules` function on your tree in the required NEXUS format. This will create the necessary CAOS rules and files to use for classification.

* Once you have generated your CAOS rules, you can load them with the function `load_tree`.

* Lastly run the `classify_new_sequence` function on the sequence you wish to classify.

## NEXUS File Format

In order for the parser to correctly extract all relevant information from your phylogeneitc tree, your NEXUS file must be in the exact format described below (most NEXUS files will already be in this format, but if you are having issues with your file being read properly, here is how to format it):

* The tree must in Newick format
* The tree must be on a line with the words "TREE" and "="
* The character labels (names associated with each sequence of characters) should be directly after a line with the word "MATRIX" (this should be the only time the word "MATRIX" appears in the file)
* Each character label should be its own line, with the name followed by a number of space, and then the character sequence
* After your last character label, the following line should contain only a ";"
* Taxa labels (taxa numbers for the position in the newick formatted tree associated with each character sequence name) should appear directly after a line containing the word "TRANSLATE" (this should be the only occurrence of that word in the file)
* Each taxa label should be its own line, with the taxa number followed by the character sequence name (at least one space in between the two)
* The line with the last taxa label should end with a ";"

## Examples

Two example NEXUS files are provided in the `test/data` folder : `S10593.nex` and `E1E2L1.nex`

An example sequence file is provided in the `test/data` folder : `Example_Sequence.txt`

#### Functions

```
generate_caos_rules("test/data/S10593.nex", "test/data")
```
This will generate your CAOS rules for the tree in the `S10593.nex` NEXUS file and place all output files from rule generation in the `test/data` directory.

```
tree, character_labels, taxa_labels = load_tree("test/data")
```
This will load the internal representation of the tree and CAOS rules from the files output during rule generation in the `test/data` directory.

```
classification = classify_new_sequence(tree, character_labels, taxa_labels, "test/data/Example_Sequence.txt", "test/data")
```
This will return the classification result, either a string with the classification label or a Node object (under classifiction).
