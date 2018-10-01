"""
    CA_matches(sequence::String, CAs::Vector{Rule}, CA_weights::Dict{String,Int64}, occurrence_weighting::Bool)

Counts the number of CA's matched by a sequence (only support for simple rules).

# Arguments
- `sequence::String`: sequence to count matches.
- `CAs::Vector{Rule}`: list of all CA's.
- `CA_weights::Dict{String,Int64}`: weights to use for CA counts.
- `occurrence_weighting::Bool`: whether to use occurrence weighting during counting.
"""
function CA_matches(sequence::String, CAs::Vector{Rule}, CA_weights::Dict{String,Int64}, occurrence_weighting::Bool)

    letter_transformations = Dict{Char,Vector{Char}}('A'=>['A'], 'T'=>['T'], 'C'=>['C'], 'G'=>['G'], 'U'=>['U'], 'R'=>['A','G'], 'Y'=>['C','T'], 'S'=>['G','C'], 'W'=>['A','T'], 'K'=>['G','T'], 'M'=>['A','C'], 'B'=>['C','G','T'], 'D'=>['A','G','T'], 'H'=>['A','C','T'], 'V'=>['A','C','G'], 'N'=>['A','T','C','G'], '-'=>['-'])

    used_idxs = Array{Int,1}()

    # Initialize CAOS score
    total_score = 0

    # Iterate through each rule
    for rule in CAs

        # Initialize variables
        is_match = true
        score = 1

        # Check if the sequence follows the rule
        for (iter,idx) in enumerate(rule.idxs)

            if idx in used_idxs
                is_match = false
                break
            end

            seq_letters = letter_transformations[sequence[idx]]

            if !(rule.char_attr[iter] in seq_letters)
                is_match = false
                break
            end
        end

        # Keep track of score
        if is_match

            push!(used_idxs, (rule.idxs)[1])

            # Add value of pure/private rule
            if rule.is_pure
                if length(rule.char_attr) == 1
                    score *= CA_weights["sPu"]
                else
                    score *= CA_weights["cPu"]
                end
            else
                if length(rule.char_attr) == 1
                    score *= CA_weights["sPr"]
                    if occurrence_weighting
                        score *= rule.occurances/rule.num_group
                    end
                else
                    score *= CA_weights["cPr"]
                    if occurrence_weighting
                        score *= rule.occurances/rule.num_group
                    end
                end
            end

            # Add to total score
            total_score += score
        end
    end

    # Return CAOS score
    return Int(round(total_score))
end

"""
    classify_sequence(sequence::String, tree::Node, CA_weights::Dict{String,Int64},
    all_CA_weights::Dict{Int64,Dict{String,Int64}}, occurrence_weighting::Bool,
    depth::Int64, tiebreaker::Vector{Dict{String,Int64}} ; blast_results=["Fake Label"], combo_classification::Bool=false)

Classifies an input sequence given a phylogentic tree.

# Arguments
- `sequence::String`: sequence to count matches.
- `tree::Node`: the tree represented as a Node.
- `CA_weights::Dict{String,Int64}`: weights to use for CA counts.
- `all_CA_weights::Dict{Int64,Dict{String,Int64}}`: all sets of weights to use for CA counts.
- `occurrence_weighting::Bool`: whether to use occurrence weighting during counting.
- `depth::Int64`: current depth of the tree.
- `tiebreaker::Vector{Dict{String,Int64}}`: tiebreaking procedures to use.
- `blast_results=["Fake Label"]`: list of blast results.
- `combo_classification::Bool=false`: whether to use both Blast and CAOS for classification.
"""
function classify_sequence(sequence::String, tree::Node, CA_weights::Dict{String,Int64}, all_CA_weights::Dict{Int64,Dict{String,Int64}}, occurrence_weighting::Bool, depth::Int64, tiebreaker::Vector{Dict{String,Int64}} ; blast_results=["Fake Label"], combo_classification::Bool=false)

    if haskey(all_CA_weights, depth)
        CA_weights = all_CA_weights[depth]
    end

    # If at a terminal node, return the taxa label
    if length(tree.children) == 0
        return tree.taxa_label

    # Get the CA score for each child
    else


        if false && combo_classification && (length(blast_results) >= 10)
            for child in tree.children
                descendents = get_descendents(child)
                all_blast = true
                for blast_result in blast_results[1:10]
                    if !(blast_result in descendents)
                        all_blast = false
                        break
                    end
                end
                if all_bast
                    return classify_sequence(sequence,child,CA_weights,all_CA_weights,occurrence_weighting,depth+1,tiebreaker, blast_results=blast_results, combo_classification=combo_classification)
                end
            end
        end


        child_CA_score = Array{Int,1}()
        for child in tree.children
            push!(child_CA_score, CA_matches(sequence, child.CAs, CA_weights, occurrence_weighting))
        end

        max_child_idx = findall(score -> score == maximum(child_CA_score), child_CA_score)

        # Select the child with highest CA score and descend in that direction
        if length(max_child_idx) == 1
            return classify_sequence(sequence,tree.children[max_child_idx[1]],CA_weights,all_CA_weights,occurrence_weighting,depth+1,tiebreaker, blast_results=blast_results, combo_classification=combo_classification)

        # If there is a tie, return either use the tiebreaker or return the tree
        elseif tiebreaker[1] == Dict{String,Int64}()
            if combo_classification && (length(blast_results) >= 5)
                for child in tree.children
                    descendents = get_descendents(child)
                    top_blasts = true
                    for blast_result in blast_results[1:5]
                        if !(blast_result in descendents)
                            top_blasts = false
                            break
                        end
                    end
                    if top_blasts
                        return classify_sequence(sequence,child,CA_weights,all_CA_weights,occurrence_weighting,depth+1,tiebreaker, blast_results=blast_results, combo_classification=combo_classification)
                    end
                end
            end
            return tree
        else
            return classify_sequence(sequence,tree,tiebreaker[1],Dict{Int,Dict{String,Int64}}(),occurrence_weighting,depth,tiebreaker[2:end], blast_results=blast_results, combo_classification=combo_classification)
        end
    end
end

"""
    CV_classification(taxa_label::String, character_labels::Dict{String,String},
    gene::String, percent_test::String, all_CA_weights::Dict{Int,Dict{String,Int64}},
    occurrence_weighting::Bool, tiebreaker::Vector{Dict{String,Int64}}; combo_classification::Bool=false)

Gets the classification for a LOOCV tree.

# Arguments
- `taxa_label::String`: taxa to classify.
- `character_labels::Dict{String,String}`: a mapping of the character labels to the corresponding sequences.
- `gene::String`: gene which is being classified.
- `percent_test::String`: percent we are testing on.
- `all_CA_weights::Dict{Int64,Dict{String,Int64}}`: all sets of weights to use for CA counts.
- `occurrence_weighting::Bool`: whether to use occurrence weighting during counting.
- `tiebreaker::Vector{Dict{String,Int64}}`: tiebreaking procedures to use.
- `combo_classification::Bool=false`: whether to use both Blast and CAOS for classification.
"""
function CV_classification(taxa_label::String, character_labels::Dict{String,String}, gene::String, percent_test::String, all_CA_weights::Dict{Int,Dict{String,Int64}}, occurrence_weighting::Bool, tiebreaker::Vector{Dict{String,Int64}}; combo_classification::Bool=false)

    home_dir = "/users/jkatz/scratch/Desktop"

    character_labels_no_gaps = remove_blanks(character_labels)

    # Get the new sequence after imputing blanks
    new_seq,blast_results = add_blanks("$home_dir/Trees_Genes/$gene/$percent_test/queries/Query_$taxa_label.txt", "$home_dir/Trees_Genes/$gene/$percent_test/char_labels.fasta", character_labels, character_labels_no_gaps, return_blast=true)

    if new_seq == "Error"
        return new_seq
    end

    # Load tree from json
    open("$home_dir/Trees_Genes/$gene/$percent_test/tree.json", "r") do f
        global loaded_tree
        loaded_tree=JSON.parse(f)  # parse and transform data
    end

    tree_load = Node([])

    # Get tree back into proper format
    CV_tree = convert_to_struct(loaded_tree, tree_load)

    # Classify the sequence
    classification = classify_sequence(new_seq, CV_tree, all_CA_weights[1], all_CA_weights, occurrence_weighting, 1, tiebreaker, blast_results=blast_results, combo_classification=combo_classification)

    return classification
end

"""
    check_CV_classification(taxa_label::String, character_labels::Dict{String,String},
    taxa_labels::Dict{String,String}, classification::Any, gene::String)

Checks if the classification from a LOOCV tree is correct.

# Arguments
- `taxa_label::String`: taxa to classify.
- `character_labels::Dict{String,String}`: a mapping of the character labels to the corresponding sequences.
- `taxa_labels::Dict{String,String}`: a mapping of the taxa labels to the character labels.
- `classification::Any`: the classification to check.
- `gene::String`: gene which is being classified.
"""
function check_CV_classification(taxa_label::String, character_labels::Dict{String,String}, taxa_labels::Dict{String,String}, classification::Any, gene::String)

    home_dir = "/users/jkatz/scratch/Desktop"

    # Get the original tree
    tree_load = Node([])

    # Load tree from json
    open("$home_dir/Trees_Genes/$gene/tree.json", "r") do f
        global loaded_tree
        loaded_tree=JSON.parse(f)  # parse and transform data
    end

    # Sequence label
    seq_name = taxa_labels["$taxa_label"]

    # Get tree back into proper format
    original_tree = convert_to_struct(loaded_tree, tree_load)

    # Get the neighbors
    neighbors = get_all_neighbors(original_tree, character_labels, seq_name)

    # If classification is a tree
    if typeof(classification) == Node

        # Get sequence subtree
        seq_subtree = find_sequence(original_tree, seq_name)

        # Get neighbors of sequence subtree
        neighbors_without_duplicates = get_neighbors(seq_subtree, seq_name)

        # Get the tree that was returned as the classification
        classification_tree = get_neighbors(classification, "Fake Taxa Label")

        # Check if the tree of sequence is a subtree of the classifcation tree
        missing_elements = setdiff(classification_tree, neighbors_without_duplicates)

        # Does the classifciation contain the subtree containing the target sequence
        if length(missing_elements) == 0
            return "Correct"
        elseif length(missing_elements) == length(neighbors_without_duplicates)
            return "Incorrect tree"
        else
            return "Under Classification"
        end

    # Did the classification find a neighbor
    else
        if classification in neighbors
            return "Correct"
        else
            return "Incorrect"
        end
    end
end

# Function to classify all sequences using CAOS and LOOCV
"""
    classify_all_CV(character_labels::Dict{String,String}, taxa_labels::Dict{String,String},
    gene::String, percent_test::String ; blast_only::Bool=false,
    all_CA_weights::Dict{Int64,Dict{String,Int64}}=Dict(1=>Dict("sPu"=>1,"sPr"=>1,"cPu"=>1,"cPr"=>1)),
    occurrence_weighting::Bool=false, tiebreaker::Vector{Dict{String,Int64}}=[Dict{String,Int64}()],
    downsample::Bool=false, combo_classification::Bool=false)

Classifies all sequences using CAOS and LOOCV.

# Arguments
- `character_labels::Dict{String,String}`: a mapping of the character labels to the corresponding sequences.
- `taxa_labels::Dict{String,String}`: a mapping of the taxa labels to the character labels.
- `gene::String`: gene which is being classified.
- `percent_test::String`: percent we are testing on.
- `blast_only::Bool=false`: whether we are only using Blast to classify.
- `all_CA_weights::Dict{Int64,Dict{String,Int64}}=Dict(1=>Dict("sPu"=>1,"sPr"=>1,"cPu"=>1,"cPr"=>1))`: CA weights to be used.
- `occurrence_weighting::Bool=false`: whether to use occurence weighting in classification.
- `tiebreaker::Vector{Dict{String,Int64}}=[Dict{String,Int64}()]`: tiebreaker to be used in classification.
- `downsample::Bool=false`: whether we are using downsampling.
- `combo_classification::Bool=false`: whether to use a combo of Blast and CAOS for classification.
"""
function classify_all_CV(character_labels::Dict{String,String}, taxa_labels::Dict{String,String}, gene::String, percent_test::String ; blast_only::Bool=false, all_CA_weights::Dict{Int64,Dict{String,Int64}}=Dict(1=>Dict("sPu"=>1,"sPr"=>1,"cPu"=>1,"cPr"=>1)), occurrence_weighting::Bool=false, tiebreaker::Vector{Dict{String,Int64}}=[Dict{String,Int64}()], downsample::Bool=false, combo_classification::Bool=false)

    home_dir = "/users/jkatz/scratch/Desktop"

    open("$home_dir/Trees_Genes/$gene/$percent_test/test_genes.json", "r") do f
        #global test_taxa
        test_taxa = JSON.parse(f)  # parse and transform data
    end
    test_taxa = convert(Array{String}, test_taxa)

    # Initialize variables
    matches = 0
    under_classifications = 0
    errors = Dict{String,Any}("Num_Errors"=>0,"Errors"=>[])

    if downsample
        downsample_perc = 10/float(percent_test[6:end])
        test_taxa = downsample_taxa(test_taxa, downsample_perc)
    end

    num_taxa = length(test_taxa)

    # Iterate over each sequence
    for (idx,taxon) in enumerate(test_taxa)

        # Print sequence to classify
        seq_name = taxa_labels[taxon]
        print("Attempting to classify: $seq_name ($idx out of $num_taxa) \n")

        # Get the classificaition
        if blast_only
            classification = ""
            try
                classification = blastn("$home_dir/Trees_Genes/$gene/$percent_test/queries/Query_$taxon.txt", "$home_dir/Trees_Genes/$gene/$percent_test/char_labels.fasta", ["-task", "blastn", "-max_target_seqs", 10], db=true)[1].hitname
            catch
                classification = "Error"
            end
        else
            classification = CV_classification(taxon, character_labels, gene, percent_test, all_CA_weights, occurrence_weighting, tiebreaker, combo_classification=combo_classification)
        end

        if classification == "Error"
            errors["Num_Errors"] += 1
            push!(errors["Errors"], taxon)
            print("***** ERROR ***** \n\n")
            continue
        end

        # Check the reuslt of the classification
        classification_result = check_CV_classification(taxon, character_labels, taxa_labels, classification, gene)

        # If correct add to count
        if classification_result == "Correct"
            matches += 1
            print("Success! \n\n")

        # If under classification add to counts
        elseif classification_result == "Under Classification"
            matches += 1
            under_classifications += 1
            print("Success (Under Classification) \n\n")
        else
            print("*** Classified $seq_name incorrectly *** \n\n")
        end

        if mod(idx,25) == 0
            partial_results = JSON.json(Dict("Matches" => matches, "Under_Classifications" => under_classifications, "Total" => idx-errors["Num_Errors"], "Errors" => errors))
            if blast_only
                open("$gene/$percent_test/partial_blast_results.json", "w") do f
                    write(f, partial_results)
                end
            elseif combo_classification
                open("$gene/$percent_test/partial_combo_results.json", "w") do f
                    write(f, partial_results)
                end
            elseif occurrence_weighting
                open("$gene/$percent_test/partial_weighted_results.json", "w") do f
                    write(f, partial_results)
                end
            else
                open("$gene/$percent_test/partial_results.json", "w") do f
                    write(f, partial_results)
                end
            end
        end
    end

    # Return counts
    return Dict("Matches" => matches, "Under_Classifications" => under_classifications, "Total" => num_taxa-errors["Num_Errors"], "Errors" => errors)
end
