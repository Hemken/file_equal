local f1 "Z:\PUBLIC_web\Stataworkshops\stdBeta\README.txt"
local f2 "Z:\PUBLIC_web\Stataworkshops\file_equal\README.txt"

file_equal "`f1'" using "`f2'"
di r(ndif)

file_equal "`f1'" using "`f2'", display
di r(ndif)

file_equal "`f1'" using "`f2'", range(1 5)
file_equal "`f1'" using "`f2'", display range(1 5)
file_equal "`f1'" using "`f2'", display range(2 5)

/*
mata: fcompare("`f1'", "`f2'", 1, 0, .)
di r(differences)

mata: fcompare("`f1'", "`f2'", 0, 1, 5)
di r(differences)

mata: fcompare("`f1'", "`f2'", 1, 0, 5)
di r(differences)
mata: fcompare("`f1'", "`f2'", 1, 1, 5)
di r(differences)
mata: fcompare("`f1'", "`f2'", 1, 2, 5)
di r(differences)
*/
