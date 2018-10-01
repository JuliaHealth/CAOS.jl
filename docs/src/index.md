# Characteristic Attribute Organization System (CAOS).

This package provides an interface to use the CAOS algorithm for sequence classification. 

#### Workflow

* First run the `generate_caos_rules` function on your tree in the required NEXUS format. This will create the necessary CAOS rules and files to use for classification.

* Once you have generated your CAOS rules, you can load them with the function `load_tree`.

* Lastly run the `classify_new_sequence` function on the sequence you wish to classify.

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
