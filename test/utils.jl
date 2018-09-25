@testset "utils" begin

    @testset "remove_blanks" begin
        d = Dict("a" => "-", "b" => "2")
        d1 = remove_blanks(d)
        d2 = remove_blanks(d, change_to_N=true)
        @test d1["a"] == ""
        @test d2["a"] == "N"
    end

    @testset "get_max_depth" begin
        tree, character_labels, taxa_labels = generate_caos_rules("data/S10593.nex", "data/output")
        tree_out = load_tree("data/output")
        println(length(tree_out[1].children))
        println(get_max_depth(tree_out[1], 10))
        @test typeof(tree_out[1]) == CAOS.Node
    end

end
