# Only for simple rules
function generate_caos_rules(tree_file_path::String, output_directory::String)

    # Parse the tree and prepare data for CA's
    nodes, taxa_labels, character_labels, _ = parse_tree(tree_file_path)

    # Initialize variables for constructing tree
    sPu, sPr = get_sPu_and_sPr(nodes, 1, taxa_labels, character_labels)
    cPu = Array{Dict{String,Any}}(0)
    cPr = Array{Dict{String,Any}}(0)
    #cPu,cPr = get_cPu_and_cPr(nodes,1,taxa_labels,character_labels,sPu,sPr)

    # Get CA's for tree
    tree = Node([])
    add_nodes(tree,sPu,sPr,cPu,cPr,taxa_labels,character_labels,nodes,1,complex=false)

    # Save tree to json
    tree_data = JSON.json(tree)
    open("$output_directory/caos_rules.json", "w") do f
        write(f, tree_data)
    end

    # Change blanks to N's for the database
    character_labels_no_gaps = remove_blanks(character_labels)

    # Create fasta file from dictionary of character labels
    writefasta("$output_directory/char_labels.fasta", character_labels_no_gaps)

    # Create the blast database
    run(`makeblastdb -in $output_directory/char_labels.fasta -dbtype nucl`)

    # Save character and taxa labels
    character_data = JSON.json(character_labels)
    open("$output_directory/character_labels.json", "w") do f
        write(f, character_data)
    end
    taxa_data = JSON.json(taxa_labels)
    open("$output_directory/taxa_labels.json", "w") do f
        write(f, taxa_data)
    end

    return tree, character_labels, taxa_labels

end

function classify_new_sequence(tree::Node, character_labels::Dict{String,String}, taxa_labels::Dict{String,String}, sequence_file_path::String, output_directory::String ; all_CA_weights::Dict{Int64,Dict{String,Int64}}=Dict(1=>Dict("sPu"=>1,"sPr"=>1,"cPu"=>1,"cPr"=>1)), occurrence_weighting::Bool=false, tiebreaker::Vector{Dict{String,Int64}}=[Dict{String,Int64}()], combo_classification::Bool=false)

    character_labels_no_gaps = remove_blanks(character_labels)

    # Get the new sequence after imputing blanks
    new_seq,blast_results = add_blanks("$sequence_file_path", "$output_directory/char_labels.fasta", character_labels, character_labels_no_gaps, return_blast=true)

    classification = classify_sequence(new_seq, tree, all_CA_weights[1], all_CA_weights, occurrence_weighting, 1, tiebreaker, blast_results=blast_results, combo_classification=combo_classification)

    write("$output_directory/classification_result.txt", "$classification")

end

# Function to read a tree from file and convert it to a node object
function load_tree(directory::String)

    # Load tree from json
    open("$directory/caos_rules.json", "r") do f
        global loaded_tree
        loaded_tree=JSON.parse(f)  # parse and transform data
    end

    open("$directory/character_labels.json", "r") do f
        global character_labels
        character_labels=convert(Dict{String,String}, JSON.parse(f))  # parse and transform data
    end

    open("$directory/taxa_labels.json", "r") do f
        global taxa_labels
        taxa_labels=convert(Dict{String,String}, JSON.parse(f))  # parse and transform data
    end

    tree_load = Node([])

    # Get tree back into proper format
    tree = convert_to_struct(loaded_tree, tree_load)

    return tree, character_labels, taxa_labels

end
