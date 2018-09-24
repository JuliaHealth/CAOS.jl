module TestCAOS

    using CAOS
    using Test

    all_tests = [
        ("tree_functions.jl",   "           Testing: Tree functions"),
    #    ("gap_imputation.jl",     "       Testing: Gap imputation"),
    #    ("classification.jl",     "       Testing: Classification"),
    #    ("user_functions.jl",     "       Testing: User functions"),
    #    ("caos_functions.jl",     "       Testing: CAOS functions")

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
