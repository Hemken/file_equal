*! Version 2.0 - 2 November 2017                                             		
*! Author: Doug Hemken & Santiago Garriga                                                   
*! dehemken@wisc.edu      


/*===========================================================================
	based on tex_equal: A program to compare ASCII text or binary files
-----------------------------------------------------------------------
Modified:		2 November 2017 Doug Hemken
Created: 		29Jul2014	    Santiago Garriga
*===========================================================================*/
//capture program drop file_equal
program define file_equal, rclass
	version 8
	syntax anything(name=basefile)						///
		using/ 											///
		[,												///
			Display										///
			Range(numlist min=1 max=2)					///
			Lines(numlist max=1)						///
		]

*------------------------------------1.1: Error Messages ------------------------------------------
	local basefile = ustrtrim(usubinstr(`"`basefile'"', `"""', "", .))
	confirm file `"`basefile'"'
	local using = ustrtrim("`using'")
	confirm file "`using'"
	
* Range values greater than one - No more than two range values
if ("`range'" != "" ) {
	if (wordcount("`range'") == 1) {
		if `range' < 1	{
			disp in red "Only positive integers are valid in the range option"
			error			
		}
	} //  range == 1
	if (wordcount("`range'") == 2) {
		local start: word 1 of `range'
		local end: word 2 of `range'
		if `start' < 1	{
			disp in red "Only positive integers are valid in the range option"
			error			
		}
	if `start' >= `end' {
			disp in red "The start must be less than the end in the range option"
			error			
		}
	} //  range == 2
}

* Lines greater than zero - No more than one line value
if ("`lines'" != "" ) {
	if (wordcount("`lines'") == 1) {
		if `lines' < 0	{
			disp in red "Only positive integers are valid in the lines option"
			error			
		}
	} //  lines == 1
	if (wordcount("`lines'") > 2) {	
		disp in red "Only one number may be specified in the lines option"
		error
	}	//  lines > 1
	if (wordcount("`range'") == 2) & (wordcount("`lines'") == 1){	
		disp in red "The lines option was ignored"
		local lines ""
	}	
}


*------------------------------------1.2: Default Options ------------------------------------------
* Range and lines (default option for the range)
if ("`range'" != "" ) {
	local start: word 1 of `range'
	if (wordcount("`range'") == 1) & (wordcount("`lines'") == 1)	{
		local end = `start' + `lines'
	} //  range == 1
	else {
		local end: word 2 of `range'
		local lines = `end' - `start'
	} // range == 2
}

if "`start'" == "" local start = 1
if "`end'" == "" local end = .
		
*------------------------------------1.3: Program --------------------------------------------------
qui {
	tempname in1 in2	// Generate temporary names for file handles
	
	* Display Files names
	noi dis as text _new "{p 4 4 2}{cmd:base  file:} " ///
		in y  "  `basefile'" `"{browse "`basefile'":{space 10}Open }"'" {p_end}" 
	noi dis as text "{p 4 4 2}{cmd:using file:} " ///
		in y  "  `using'" `"{browse "`using'":{space 10}Open }"'" {p_end}" 
	noi dis as text "{hline}" 
	
	if "`display'" == "display" {
		local display = 1 
		}
		else {
		local display = 0
		}
		
	noi mata:fcompare("`basefile'","`using'",`display',`start',`end')

	local dif = r(differences)
	* Display Results
	if `dif' == 0 {
		noi di _skip(1) in g "Perfect comparison"
		local comparison = 1
		//local dif = 0
	}
	else {
		local comparison = 0
		if "`display'" == "1" noi dis as text "{hline}" 
		noi di "Number of differences: `dif'"
	}		
	
	* Return values
	return local using "`using'"
	return local basefile "`basefile'"
	return scalar differences = `dif'
	return scalar linenum = `linenum' - 1
	return local comparison = `comparison'

}	

end 

mata
// compare (text) files
mata drop fcompare()
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
	st_numscalar("r(differences)", differences)
	}
end
