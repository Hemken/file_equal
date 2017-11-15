*! Version 2.2.3 - 15 November 2017                                             		
*! Author: Doug Hemken (& Santiago Garriga)
*! dehemken@wisc.edu

program define file_equal, rclass
	version 10
	syntax anything(name=basefile)					///
		using/ 										///
		[,											///
			Display									///
			Range(numlist min=1 max=2)				///
			Lines(numlist max=1)					///
		]

* File Errors --------------
	local basefile = ustrtrim(usubinstr(`"`basefile'"', `"""', "", .))
	// confirm requires local files
	confirm file `"`basefile'"'
	local using = ustrtrim("`using'")
	confirm file "`using'"
	//display "  {it: Checked files} - OK"
	
* Range Defaults and Errors --------------
if ("`range'" != "" ) {
	local start: word 1 of `range'
	if (`start' < 1 ) {
		display {error: "  Range must be positive."}
		error			
	}
	else if (wordcount("`range'") == 2) {
		//local start: word 1 of `range'
		local end: word 2 of `range'
		if `start' >= `end' {
			display {error: "  Range end must be >= start."}
			error			
		}
	}
	//display "  {it: Checked range option} - OK"
}

* Lines Defaults and Errors --------------
if ("`lines'" != "" ) {
		if (`lines' <= 0) {
			display {error: "  Lines must be positive."}
			error			
		}
	else if (wordcount("`range'") == 2) {	
		display {error: "  The lines option was ignored"}
		local lines ""
	}
	local end = `lines'
	//display "  {it: Checked lines option} - OK"
}


*------------------------------------1.2: Default Options ------------------------------------------
* Range and lines (default option for the range)
if ("`range'" != "" ) {
	if (wordcount("`range'") == 1) & (wordcount("`lines'") == 1)	{
		local end = `start' + `lines' - 1
	}
}

if "`start'" == "" local start = 1
if "`end'" == "" local end = .
		
*------------------------------------1.3: Program --------------------------------------------------
quietly {
	* Display Files names
	noi dis as text _new "{p 4 4 2}{cmd:base  file:} " ///
		in y  "  `basefile'" `"{view "`basefile'":{space 10}Open }"'" {p_end}" 
	noi dis as text "{p 4 4 2}{cmd:using file:} " ///
		in y  "  `using'" `"{view "`using'":{space 10}Open }"'" {p_end}" 
	noi dis as text "{hline}" 
	
	if "`display'" == "display" {
		local display = 1 
		}
		else {
		local display = 0
		}
		
	noisily mata:fcompare("`basefile'","`using'",`display',`start',`end')
	
	local diff = r(differences)
	* Display Results
	if `diff' == 0 {
		noi di _skip(1) in g "All equal"
		local equal = 1
		//local dif = 0
	}
	else {
		local equal = 0
		if "`display'" == "1" noi dis as text "{hline}" 
		noi di "Number of differences: `diff'"
	}		
	
	* Return values
	return local using "`using'"
	return local basefile "`basefile'"
	return scalar differences = `diff'
	return scalar lines = r(lines) - `start' + 1
	return scalar end = `.'
	return scalar start = `start'
	return scalar equal = `equal'

}	

end 

mata:
// compare (text) files
void fcompare(string scalar filename1, string scalar filename2, ///
		numeric scalar show, numeric scalar first, numeric scalar last) {
		// filename1 - first file to compare
		// filename2 - second file to compare
		// show - 0/1 whether to display differences
		// first - first line to compare, 1/n
		// last - last line to compare, 1/.
		
	fh1 = fopen(filename1, "r")
	fh2 = fopen(filename2, "r")
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
		if (line1 != line2) {
			differences++
			if (show) {
				printf("Line %f: %s\n", linenum, line1) 
				printf("Line %f: %s\n", linenum, line2) 
				printf("%s\n", "") 
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
