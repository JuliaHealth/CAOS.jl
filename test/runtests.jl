module TestCAOS

    using CAOS
    using Test

    all_tests = [
        ("tree_functions.jl",   "           Testing: Tree functions"),
    #    ("plot_utils.jl",     "       Testing: Plot Utils")
        ]

    println("Running tests:")

    for (t, test_string) in all_tests
        println("-----------------------------------------")
        println("-----------------------------------------")
        println(test_string)
        println("-----------------------------------------")
        println("-----------------------------------------")
        include(t)
    end

end
