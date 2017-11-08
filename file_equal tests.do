cscript 

local f1 "Z:\PUBLIC_web\Stataworkshops\stdBeta\README.txt"
local f2 "Z:\PUBLIC_web\Stataworkshops\file_equal\README.txt"

capture file_equal
assert _rc != 0
capture file_equal "`f1'"
assert _rc != 0
capture file_equal using "`f1'"
assert _rc != 0

file_equal "`f1'" using "`f2'"
assert         r(equal)       == 0
assert         r(lines)       == 19
assert         r(differences) == 8

local f1 "Z:\PUBLIC_web\Stataworkshops\stdBeta\README.txt"
local f2 "Z:\PUBLIC_web\Stataworkshops\file_equal\README.txt"

file_equal "`f1'" using "`f2'", lines(3) // 2
assert         r(equal)       == 0
assert         r(lines)       == 3
assert         r(differences) == 2

file_equal "`f1'" using "`f2'", range(4) // 6
assert         r(equal)       == 0
assert         r(lines)       == 16
assert         r(differences) == 6

local f1 "Z:\PUBLIC_web\Stataworkshops\stdBeta\README.txt"
local f2 "Z:\PUBLIC_web\Stataworkshops\file_equal\README.txt"

capture file_equal "`f1'" using "`f2'", range(0)
assert _rc != 0
capture file_equal "`f1'" using "`f2'", range(-1)
assert _rc != 0
capture file_equal "`f1'" using "`f2'", range(3 1)
assert _rc != 0

local f1 "Z:\PUBLIC_web\Stataworkshops\stdBeta\README.txt"
local f2 "Z:\PUBLIC_web\Stataworkshops\file_equal\README.txt"

file_equal "`f1'" using "`f2'", range(5 9)
assert         r(equal)       == 1
assert         r(lines)       == 5
assert         r(differences) == 0

file_equal "`f1'" using "`f2'", range(5) lines(5)
assert         r(equal)       == 1
assert         r(lines)       == 5
assert         r(differences) == 0

local f1 "Z:\PUBLIC_web\Stataworkshops\stdBeta\README.txt"
local f2 "Z:\PUBLIC_web\Stataworkshops\file_equal\README.txt"

file_equal "`f1'" using "`f2'", lines(3) display // 2
file_equal "`f1'" using "`f2'", range(4) display // 6
file_equal "`f1'" using "`f2'", range(1 3) display
file_equal "`f1'" using "`f2'", range(3) display // r(ndif)==7

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
