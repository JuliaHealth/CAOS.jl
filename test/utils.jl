@testset "utils" begin

    @testset "remove_blanks" begin
        d = Dict("a" => "-", "b" => "2")
        d1 = remove_blanks(d)
        d2 = remove_blanks(d, change_to_N=true)
        @test d1["a"] == ""
        @test d2["a"] == "N"
    end

    @testset "get_max_depth" begin
        tree = load_tree("data/output")
        println(length(tree[1].children))
        println(get_max_depth(tree[1], 10))
        @test typeof(tree[1]) == CAOS.Node
    end

end
