mata:
// compare (text) files
void fcompare(string scalar filename1, string scalar filename2, ///
		numeric scalar show, numeric scalar first, numeric scalar last, ///
		| string scalar except) {
		// filename1 - first file to compare
		// filename2 - second file to compare
		// show - 0/1 whether to display differences
		// first - first line to compare, 1/n
		// last - last line to compare, 1/.
		// except - list of lines to skip, 1/n, optional
		
	fh1 = fopen(filename1, "r")
	fh2 = fopen(filename2, "r")
	
	if (except == "") {
		skips = 0
		}
		else {
		skips = strtoreal(tokens(except))
		}
	//printf("skips="); skips
	
	// initialize
	differences = 0
	linenum = 1
	if (first > 1) {
		for (linenum = 1; linenum<=first-1; linenum++){
			line1=fget(fh1)
			line2=fget(fh2)
			}
		}
	// compare
	
	while ((line1=fget(fh1))!=J(0,0,"") & (line2=fget(fh2))!=J(0,0,"") & ///
			linenum>=1 & linenum <= last) {
		if (cols(select(1..cols(skips), linenum:==skips))==0) {
		//cols(select(1..cols(skips), linenum:==skips)) ==0
		if (line1 != line2) {
			differences++
			if (show) {
				printf("Line %f: %s\n", linenum, line1) 
				printf("Line %f: %s\n", linenum, line2) 
				printf("%s\n", "") 
				}
		    }
			}
		linenum++
        }
	
	fclose(0)
	fclose(1)
	// finish and return
	st_numscalar("r(lines)", linenum-1)
	st_numscalar("r(differences)", differences)
	}
end



local f1 "Z:\PUBLIC_web\Stataworkshops\stdBeta\README.txt"
local f2 "Z:\PUBLIC_web\Stataworkshops\file_equal\README.txt"

mata: fcompare("`f1'", "`f2'", 0, 0, .)
di r(differences)
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
