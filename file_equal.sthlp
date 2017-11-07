{smcl}
{* *! version 2.2   7Nov2017}{...}
{viewerjumpto "Syntax" "file_equal##syntax"}{...}
{viewerjumpto "Description" "file_equal##description"}{...}
{viewerjumpto "Options" "file_equal##options"}{...}
{viewerjumpto "Stored Results" "file_equal##stored"}{...}
{title:Title}

{p 4 11 2}
{hi:file_equal} {hline 2} Compare two text files, line by line{p_end}


{marker syntax}{title:Syntax}

{p 8 15 2}
{cmd:file_equal} {it:basefile} using {it:filename}
[, {break}
{cmd:display} {break}
{cmd:range}({it:numlist}) {break}
{cmd:lines}({it:integer})]

{synoptset 35 tabbed}{...}
{synopthdr:{it:}{col 18}}
{syntab: Main}
{synoptline}
{synopt : {cmdab:basefile}}Name of the first file.{p_end}
{synopt : {cmdab:filename}}Name of the second, comparison file.{p_end}
   
{syntab: Options}
{synoptline}
{synopt :{opt display}}Display any differences.{p_end}
{synopt :{opt range}(#[/#])}Line range to compare.{p_end}
{synopt :{opt lines}(integer)}Number of lines to compare.{p_end}
{synoptline}

{marker description}{title:Description}

{pstd} {cmd:file_equal} compares the contents of {it:basefile} with {it:filename}. 
The comparison is done line by line
i.e. line 1 in {it:basefile} against line 1 of {it:filename}. 

{pstd} It is possible to compare just a portion of the file(s)
 using the {it:range} and/or {it:lines} options.

{pstd} You can see the discrepancies between the files by using the
{it:display} option.

{marker options}{title:Options}

{dlgtab:Main}

{phang}
{cmd: basename}{it:(basename)} name of the first file. Include the file extension,
	i.e. .do, .ado, .txt, or anything else.

{phang}
{cmd: filename}{it:(filename)} name of the second file, including the file extension.
   
{dlgtab:Options}

{phang}
{cmd: display} show the discrepancies between files, if any. 
	This presents the line number
	and the complete text in each file at that line.
	
{phang}
{cmd: range}{it:(#[/#])} specify a range of lines over which to compare. If
 two integers are specified, the comparison will be done over those lines of the file. 
 
{pmore}
 If one integer
 is specified, the comparison begins at line #.
 
{pmore}
 If one integer is specified along with the {it:lines} option, lines # through (# + lines)
 are compared.

{phang}
{cmd: lines}{it:(#)} The number of lines to compare - defaults to all lines.
If a complete range is provided in the {it:range} option, i.e. two 
	integers, this option is ignored.{p_end}

	
{marker stored}{title:Stored results}

{p 4 2 1}
{cmd:file_equal} stores the following in {cmd:r()}:

{synopt:{cmd:r(comparison)}}1 if files are the same, 0 otherwise{p_end}
{synopt:{cmd:r(lines)}}number of lines compared{p_end}
{synopt:{cmd:r(ndif)}}number of differences if any{p_end}
{synopt:{cmd:r(basefile)}}Name of {it:basefile}{p_end}
{synopt:{cmd:r(using)}}Name of {it:filename}{p_end}
		
{title:Authors}

{p 4} Doug Hemken {p_end}
{p 4} Social Science Computing Cooperative{p_end}
{p 4} Univ of Wisc-Madison{p_end}
{p 4} {browse "mailto:dehemken@wisc.edu":dehemken@wisc.edu}
{p 4} https://www.ssc.wisc.edu/~hemken/Stataworkshops
{p 4} https://github.com/Hemken/file_equal

{p 4} based on {cmd:tex_equal} by{p_end}
{p 4} Santiago Garriga {p_end}
{p 4} Facultad de Ciencias Económicas (UNLP - Argentina)  {p_end}
{p 4} LCSPP - World Bank {p_end}


