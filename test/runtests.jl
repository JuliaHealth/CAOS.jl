using CAOS

tree, character_labels, taxa_labels = generate_caos_rules("/data/S10593.nex", "/data/output")

@test typeof(tree) == Node

# classification = classify_new_sequence(tree, character_labels, taxa_labels, "/data/Example_Sequence.txt", "/data/output")

# @test typeof(classification) == String

tree2, character_labels2, taxa_labels2 = load_tree("/data/output")

@test typeof(tree2) == Node
