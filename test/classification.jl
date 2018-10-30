@testset "classification" begin

    generate_caos_rules("data/S10593.nex", "data/output")
    tree, character_labels, taxa_labels = load_tree("data/output")
    
    @testset "classify_sequence" begin
        classification = classify_new_sequence(tree, character_labels, taxa_labels, "data/Example_Sequence.txt", "data/output")
        @test classification == "Tubificoides_amplivasatus_II_CE1247"
    end


end
