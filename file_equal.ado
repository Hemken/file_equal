*! Version 2.0 - 30 October 2017                                             		
*! Author: Doug Hemken & Santiago Garriga                                                   
*! dehemken@wisc.edu      


/* *===========================================================================
	based on tex_equal: Program to compare ASCII text or binary files
	Reference: 
-------------------------------------------------------------------
Modified:		30 Oct 2017 Doug Hemken
Created: 		29Jul2014	Santiago Garriga
*===========================================================================*/

program define file_equal, rclass
	version 8
	syntax anything(name=basefile)						///
		using/ 											///
		[,												///
			display										///
			range(numlist min=1 max=2)					///
			lines(numlist max=1)						///
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

* Lines greater than Zero - No more than one line value
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
	
	** Base file **
	
	file open `in1' using "`basefile'", read
	file read `in1' line
	
	** Using file **	
	
	file open `in2' using "`using'", read
	file read `in2' line2
	

	* Generate local counting lines
	local linenum = 1						// Line number
	local dif = 0							// Number of differences
	
	
	* Generate local counting lines
	while r(eof) == 0 & `linenum' < `start'  {	// Jump from the first line to the start line
		local ++linenum		
		file read `in1' line
		file read `in2' line2	
	}
	
	
	* Analyze relevant section of the file
	while r(eof) == 0  & `linenum' >= `start' &  `linenum' <= `end'  {	// Compare and continue
		
		if `"`macval(line)'"'!=`"`macval(line2)'"' {
			
			if "`display'" == "display" {
			
				noi display in g `"`linenum' : "' _col(8) _asis in y `"`macval(line)'"' _newline(1) ///
								 `"`linenum' : "' _col(8) _asis in y `"`macval(line2)'"' _newline(1) 
			}
			local ++dif		
		}
		local ++linenum		
		file read `in1' line
		file read `in2' line2			
	}

	* Display Results
	if `dif' == 0 {
		noi di _skip(1) in g "Perfect comparison"
		local comparison = 1
		local dif = 0
	}
	else {
		local comparison = 0
		if "`display'" == "display" noi dis as text "{hline}" 
		noi di "Number of differences: `dif'"
	}		
	
	* Return values
	return local using "`using'"
	return local basefile "`basefile'"
	return scalar ndif = `dif'
	return scalar linenum = `linenum' - 1
	return local comparison = `comparison'

}	

end 

exit
