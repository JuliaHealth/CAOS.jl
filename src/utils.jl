# Function to change the blanks in a dictionary of character labels to N's
function remove_blanks(char_label_dict::Dict{String,String} ; change_to_N::Bool=false)
    character_labels_no_blanks = Dict{String,String}()
    for (key,value) in char_label_dict
        if change_to_N
            character_labels_no_blanks[key] = replace(value, "-", "N")
        else
            character_labels_no_blanks[key] = replace(value, "-", "")
        end
    end
    return character_labels_no_blanks
end

# Function to get the max depth of a tree
function get_max_depth(tree::Node, depth::Int64)

    # Initialize varibale
    depths = Array{Int,1}()

    # If no children
    if length(tree.children) == 0

        # If original tree, return 0
        if depth == 0
            return 0

        # Else return the depth
        else
            return [depth]
        end

    # If tree still has children recur on each child
    else
        for child in tree.children

            # Append max depth of each child
            append!(depths, get_max_depth(child, depth+1))
        end
    end

    # Return the maximum of all depths
    return maximum(depths)
end

# Function to get the smallest subtree that contains the given taxa
function find_sequence(tree::Node, taxa_label::String)

    # Initialize variables
    subtree = ""

    # Iterate over each child in the tree
    for child in tree.children

        # Get the child's taxa label
        label = child.taxa_label

        # If the child's label is the input label return the subtree
        if label == taxa_label
            return tree

        # If the child is a tree then recur on the child
        elseif label == ""
            subtree = find_sequence(child, taxa_label)

            # Once we find the taxa label, return the subtree
            if isa(subtree, Node)
                return subtree
            end
        end
    end
end

# Function to get the neighbors of a taxa (taxa that come after from the subtree containing the input taxa)
function get_neighbors(tree::Node, taxa_label::String)

    # Initialize variables
    neighbors = Array{String,1}()

    # Iterate over each child in the tree
    for child in tree.children

        # Get the child's taxa label
        label = child.taxa_label

        # If the taxa_label isn't the input taxa
        if !(label == taxa_label)

            # If the child is a subtree, add all descendents from that tree
            if label == ""
                append!(neighbors, get_neighbors(child, taxa_label))

            # If the child is a terminal node, add that label to the neighbors
            else
                push!(neighbors, label)
            end
        end
    end

    # Return neighbor list
    return neighbors
end

# Function to get all the duplicate labels that exist
function get_duplicate_labels(character_labels::Dict{String,String}, label::String)

    # Initialize variables
    duplicates = Array{String,1}()

    # Iterate over each sequence
    for (key,val) in character_labels

        # If the sequence label is not the input label
        if !(key == label)

            # If the sequence is the same as the input sequence add to duplicate list
            if val == character_labels[label]
                push!(duplicates, key)
            end
        end
    end

    # Return duplicate list
    return duplicates
end

# Function to get all the possible neighbors of a taxa (duplicates included)
function get_all_neighbors(tree::Node, character_labels::Dict{String,String}, taxa_label::String)

    # Get the subtree for the input taxa
    subtree = find_sequence(tree, taxa_label)

    # Get the neighbors for the input taxa
    neighbors = get_neighbors(subtree, taxa_label)

    # Get all the duplicate labels
    duplicates = get_duplicate_labels(character_labels, taxa_label)

    # Iterate over all duplicate labels
    for label in duplicates

        # Get the subtree
        duplicate_subtree = find_sequence(tree, label)

        # Get the neighbors
        duplicate_neighbors = get_neighbors(duplicate_subtree, label)

        # Add neighbors from the duplicate label
        append!(neighbors, duplicate_neighbors)
    end

    # Return the set of all neighbors
    return unique(neighbors)
end

# Function to adjust the start of the matched subject based on its blanks
function get_adjusted_start(original_start::Int, subject::String)

    # Initialize variables
    num_blanks = 0
    num_non_blanks = 0

    # Iterate through each character of the subject with blanks (N's)
    for character in subject

        # If an N, add to blank count
        if character == '-'
            num_blanks += 1
        else
            num_non_blanks += 1
            if num_non_blanks == original_start
                break
            end
        end
    end

    return original_start + num_blanks
end

# Function to extract a taxa label from a tree
function get_first_taxa_from_tree(tree::Node)
    if tree.taxa_label == ""
        fefn
    else get_first_taxa_from_tree(tree.children[1])
        return tree.taxa_label
    end
end

# Function to downsample a set of taxa
function downsample_taxa(taxa::Array{String}, perc_keep::Float64)
    num_total_taxa = 1
    num_new_taxa = 0
    new_taxa = Array{String,1}()
    for taxon in taxa
        if num_new_taxa/num_total_taxa < perc_keep
            push!(new_taxa, taxon)
            num_new_taxa += 1
        end
        num_total_taxa += 1
    end
    return new_taxa
end

# Function to get all descendents of a tree
function get_descendents(tree::Node)

    # Initialize variables
    descendents = Array{String,1}()

    if tree.taxa_label == ""
        # Iterate over each child in the tree
        for child in tree.children

            # Get the child's taxa label
            label = child.taxa_label

            # If the taxa_label isn't the input taxa
            if label == ""

                # If the child is a subtree, add all descendents from that tree
                append!(descendents, get_descendents(child))

            # If the child is a terminal node, add that label to the neighbors
            else
                push!(descendents, label)
            end
        end

    else
        push!(descendents, tree.taxa_label)
    end

    # Return neighbor list
    return descendents
end
