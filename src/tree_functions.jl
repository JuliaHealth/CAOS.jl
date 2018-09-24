# Struct to store relevant information about a CA
struct Rule
    idxs::Tuple{Vararg{Int}}
    char_attr::Tuple{Vararg{Char}}
    is_pure::Bool
    num_group::Int
    num_non_group::Int
    occurances::Int
end

# Struct to store a node (is recursive)
struct Node
    CAs::Array{Rule,1}
    children::Array{Node,1}
    taxa_label::String

    function Node(CAs ; label="")
        return new(CAs, Array{Node,1}(), label)
    end
end

# Function to remove a specific taxa from a tree in Newick Format
function remove_from_tree!(tree_tokens::Vector{String}, taxa_to_remove::Union{Array{String,1},Bool})

    tokens_removed = 0

    old_tree_tokens = deepcopy(tree_tokens)

    # Iterate through tokens in tree
    for (idx,char) in enumerate(old_tree_tokens)

        # If the current character is the taxa to remove
        if (char in taxa_to_remove) || (char == "$taxa_to_remove")

            # Remove preceeding comma and taxa number in tree
            if old_tree_tokens[idx-1] == ","
                deleteat!(tree_tokens, idx-1-tokens_removed)
                deleteat!(tree_tokens, idx-1-tokens_removed)
                tokens_removed += 2

            # Remove succeeding comma and taxa number in tree
            elseif old_tree_tokens[idx+1] == ","
                deleteat!(tree_tokens, idx-tokens_removed)
                deleteat!(tree_tokens, idx-tokens_removed)
                tokens_removed += 2

            # Remove parenthesis, comma, and taxa number in tree
            elseif (old_tree_tokens[idx-1] == "(") && (old_tree_tokens[idx+1] == ")")
                if old_tree_tokens[idx-2] == ","
                    deleteat!(tree_tokens, idx-2-tokens_removed)
                    deleteat!(tree_tokens, idx-2-tokens_removed)
                    deleteat!(tree_tokens, idx-2-tokens_removed)
                    deleteat!(tree_tokens, idx-2-tokens_removed)
                elseif old_tree_tokens[idx+2] == ","
                    deleteat!(tree_tokens, idx-1-tokens_removed)
                    deleteat!(tree_tokens, idx-1-tokens_removed)
                    deleteat!(tree_tokens, idx-1-tokens_removed)
                    deleteat!(tree_tokens, idx-1-tokens_removed)
                end
                tokens_removed += 4
            else
                print("$char \n")
            end
        end
    end

    # Return new tree tokens with taxa removed
    return tree_tokens
end

# Function to produce nodes and relevant groups and taxa from a tree in newick form
function get_nodes(tree::String ; taxa_to_remove::Union{Array{String,1},Bool}=false)

    # Initialize variables
    num_nodes = 1
    curr_node = 1
    nodes = Array{Dict{String,Any}}(undef, 0)

    # Split tree string into tokens
    tree_tokens = [untokenize(token) for token in collect(tokenize(tree))]

    # Remove taxa from tree if applicable
    if !(taxa_to_remove == false)
        tree_tokens = remove_from_tree!(tree_tokens, taxa_to_remove)
    end

    # Iterate through each token
    for (idx, char) in enumerate(tree_tokens)

        # Start of a new node
        if char == "("
            push!(nodes, Dict{String,Any}("Groups" => 0, "Taxa" => Array{String}(undef, 0), "Descendents" => Array{Int}(undef, 0)))
            paren = 1

            # Iterate through the rest of the tree tokens
            for char in tree_tokens[idx+1:end]

                # Start of a new group
                if char == "("
                    paren += 1
                    curr_node += 1
                    if paren == 2
                        push!(nodes[num_nodes]["Descendents"], curr_node)
                    end

                # End of a group
                elseif char == ")"
                    paren -= 1
                    if paren == 0
                        nodes[num_nodes]["Groups"] += 1
                    end

                # End of a group
                elseif char == "," && paren == 1
                    nodes[num_nodes]["Groups"] += 1

                # Taxa to be added to node
                elseif char != "," && char != " "
                    push!(nodes[num_nodes]["Taxa"], char)
                end

                # End of node
                if paren == 0
                    break
                end
            end
            num_nodes += 1
            curr_node = num_nodes
        end
    end
    return nodes
end

# Function to parse a newick tree file into nodes and labels matching character sequences
function parse_tree(file_path::String ; taxa_to_remove::Any=false)

    # Initialize variables
    character_labels = Dict{String,String}()
    taxa_labels = Dict{String,String}()
    labels = false
    character_counter = 3
    file = open(file_path)
    nodes = Array{Dict{String,Any}}(undef, 0)
    title_count = 0
    name = "NoName"

    # Iterate through each line of the file
    for line in eachline(file)

        if occursin("TITLE ", line)
            title_count += 1
            if title_count == 2
                name = untokenize(collect(tokenize(line))[4])
            end
        end

        # Get nodes for the tree
        if occursin("TREE ", line) && occursin("=", line)
            nodes = get_nodes(line, taxa_to_remove=taxa_to_remove)
            break
        end

        # Match the character sequences with their labels
        if character_counter == 2
            idxs = Array{Int}(undef, 0)
            for (idx, char) in enumerate(line)
                if char == ' '
                    push!(idxs, idx)
                elseif char == '-'
                    break
                end
            end
            if line[1] == ';'
                character_counter = 2
            else
                character_counter = 1
                character_labels[line[1:idxs[1]-1]] = line[idxs[end]+1:end]
            end
        end
        character_counter += 1

        # Match the taxa with their labels
        if labels
            label_tokens = collect(tokenize(line))
            temp_labels = Array{String}(undef, 0)
            for token in label_tokens
                if token.kind != collect(tokenize(" "))[1].kind
                    push!(temp_labels, untokenize(token))
                    if length(temp_labels) == 2
                        break
                    end
                end
            end
            taxa_labels[temp_labels[1]] = temp_labels[2]
            if occursin(";", line)
                labels = false
            end
        end

        # Differentiate lines
        if occursin("TRANSLATE", line)
            labels = true
        end
        if line == "MATRIX"
            character_counter = 0
        end
    end
    close(file)
    return nodes, taxa_labels, character_labels, name
end

# Function to get all the CA's from all the nodes of a tree into proper format
function add_nodes!(tree::Node,sPu::Array{Dict{String,Any}},sPr::Array{Dict{String,Any}},cPu::Array{Dict{String,Any}},cPr::Array{Dict{String,Any}},taxa_labels::Dict{String,String},character_labels::Dict{String,String},nodes::Array{Dict{String,Any}},node_num::Int64;complex::Bool=true)

    # Iterate through each group at a node
    for (group_idx, taxa) in enumerate(get_group_taxa_at_node(nodes, node_num))

        # Initialize varibales
        num_group = length(taxa)
        num_non_group = length(nodes[node_num]["Taxa"]) - num_group
        num_nodes = length(nodes)

        # If terminal node, add taxa label
        if num_group == 1
            push!(tree.children, Node([],label=taxa_labels[sPr[group_idx]["Group_Taxa"][1]]))
        else
            push!(tree.children, Node([]))
        end

        # Add all the Simple Private CA's for the node
        for (idx, info) in sPr[group_idx]["sPr"]
            for CA in info
                push!(tree.children[group_idx].CAs, Rule(tuple(idx), tuple(CA[1]), false, num_group, num_non_group, CA[2]))
            end
        end

        # Add all the Simple Pure CA's for the node
        for (idx, info) in sPu[group_idx]["sPu"]
            push!(tree.children[group_idx].CAs, Rule(tuple(idx), tuple(info[1]), true, num_group, num_non_group, info[2]))
        end

        if complex
            # Add all the Complex Private CA's for the node
            for (idx, info) in cPr[group_idx]["cPr"]
                for CA in info
                    push!(tree.children[group_idx].CAs, Rule(idx, CA[1], false, num_group, num_non_group, CA[2]))
                end
            end

            # Add all the Complex Pure CA's for the node
            for (idx, info) in cPu[group_idx]["cPu"]
                push!(tree.children[group_idx].CAs, Rule(idx, info[1], true, num_group, num_non_group, info[2]))
            end
        end

        # Get descendent's CA's and recur on descendent to add next layer to tree
        if num_group > 1
            new_node_num = nodes[node_num]["Descendents"][group_idx]
            new_sPu, new_sPr = get_sPu_and_sPr(nodes, new_node_num, taxa_labels, character_labels)
            if complex
                new_cPu, new_cPr = get_cPu_and_cPr(nodes, new_node_num, taxa_labels, character_labels, new_sPu, new_sPr)
            else
                new_cPu, new_cPr = cPu, cPr
            end
            print("$node_num \n")
            add_nodes(tree.children[group_idx],new_sPu,new_sPr,new_cPu,new_cPr,taxa_labels,character_labels,nodes,new_node_num,complex=complex)
        end
    end
end
