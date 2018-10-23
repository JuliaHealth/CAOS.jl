@testset "caos_functions" begin

    @testset "get_sPu_and_sPr" begin
        tree = parse_tree("data/S10593.nex")
        nodes, taxa_labels, character_labels, title = tree
        node_num = 2
        sPu, sPr = get_sPu_and_sPr(nodes, node_num, taxa_labels, character_labels; protein=false)
        @test typeof(sPu) == Array{Dict{String,Any},1}
        @test length(sPu) == 2
        @test sPu[1]["Num_Non_Group"] == 59
        @test sPu[1]["Group_Taxa"] == ["2", "3"]
    end

    @testset "get_cPu_and_cPr" begin
        tree = parse_tree("data/S10593.nex")
        nodes, taxa_labels, character_labels, title = tree
        node_num = 2
        sPu, sPr = get_sPu_and_sPr(nodes, node_num, taxa_labels, character_labels; protein=false)
        cPu, cPr = get_cPu_and_cPr(nodes, node_num, taxa_labels, character_labels, sPu, sPr)
        @test typeof(cPu) == Array{Dict{String,Any},1}
    end

end
