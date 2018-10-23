using Tokenize
using FastaIO
using JSON
using BioTools
using BioTools.BLAST

include("caos_functions.jl")
include("tree_functions.jl")
include("utils.jl")
include("classification.jl")
include("gap_imputation.jl")

HPV_path = "/Users/JasonKatz/Desktop/BCBI/CAOS_package/test/data/E1E2L1.nex"
CAOS_path = "/Users/JasonKatz/Desktop/BCBI/CAOS_package"
nodes_full, taxa_labels, character_labels_full, _ = parse_tree(HPV_path)

for line in eachline(open(HPV_path))
    line = String(strip(replace(line, r"\[(.*?)\]" => "")))
    if occursin("TREE ", line) && occursin("=", line)
        global tree_string
        tree_string = String(strip(replace(line, r":[-+]?[0-9]*\.?[0-9]*" => "")))
    end
end
taxa = collect(keys(taxa_labels))


percent_test = 20
character_labels_CV = deepcopy(character_labels_full)
# Remove percentage of taxa and get nodes/CAOS
total_taxa = 1
test_taxa = 0
taxa_to_remove = Array{String,1}(undef, 0)
for taxon in taxa
    global test_taxa
    global total_taxa
    if test_taxa/total_taxa < percent_test/100
        push!(taxa_to_remove, taxon)
        delete!(character_labels_CV, taxa_labels[taxon])
        test_taxa += 1
    end
    total_taxa += 1
end

nodes_CV = get_nodes(tree_string, taxa_to_remove=taxa_to_remove)

sPu_CV, sPr_CV = get_sPu_and_sPr(nodes_CV, 1, taxa_labels, character_labels_full, protein=true)
cPu_CV = Array{Dict{String,Any}}(undef, 0)
cPr_CV = Array{Dict{String,Any}}(undef, 0)

tree_CV = Node([])
add_nodes!(tree_CV,sPu_CV,sPr_CV,cPu_CV,cPr_CV,taxa_labels,character_labels_full,nodes_CV,1,complex=false,protein=true)

# Save tree to json
tree_data_CV = JSON.json(tree_CV)

sPu_full, sPr_full = get_sPu_and_sPr(nodes_full, 1, taxa_labels, character_labels_full, protein=true)
cPu_full = Array{Dict{String,Any}}(undef, 0)
cPr_full = Array{Dict{String,Any}}(undef, 0)

tree_full = Node([])
add_nodes!(tree_full,sPu_full,sPr_full,cPu_full,cPr_full,taxa_labels,character_labels_full,nodes_full,1,complex=false,protein=true)
tree_data_full = JSON.json(tree_full)
# Create directory
try
    mkdir("$CAOS_path/test/HPV")
catch
end
try
    mkdir("$CAOS_path/test/HPV/test_$percent_test")
catch
end
try
    mkdir("$CAOS_path/test/HPV/test_$percent_test/queries")
catch
end
open("$CAOS_path/test/HPV/test_$percent_test/tree.json", "w") do f
    write(f, tree_data_CV)
end
open("$CAOS_path/test/HPV/tree.json", "w") do f
    write(f, tree_data_full)
end
open("$CAOS_path/test/HPV/test_$percent_test/test_genes.json", "w") do f
    write(f, JSON.json(taxa_to_remove))
end
open("$CAOS_path/test/HPV/character_labels.json", "w") do f
    write(f, JSON.json(character_labels_full))
end
open("$CAOS_path/test/HPV/taxa_labels.json", "w") do f
    write(f, JSON.json(taxa_labels))
end

# Change blanks to N for blastdb
character_labels_no_blanks = remove_blanks(character_labels_full)

# Create fasta file from dictionary of character labels
writefasta("$CAOS_path/test/HPV/test_$percent_test/char_labels.fasta", character_labels_no_blanks)

# Create the blast database
run(`makeblastdb -in $CAOS_path/test/HPV/test_$percent_test/char_labels.fasta -dbtype prot`)

for taxon in taxa_to_remove
    seq = replace(character_labels_full[taxa_labels[taxon]], "-" => "")
    # seq = replace(seq, "N", "")
    # Create query file
    write("$CAOS_path/test/HPV/test_$percent_test/queries/Query_$taxon.txt", ">" * taxa_labels[taxon] * "\n" * seq)
end1


class = classify_all_CV(character_labels_full, taxa_labels, "", "$percent_test")
