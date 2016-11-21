#!/bin/sh
# Joel Swenson 7-8-14
## shell script to run the below command repeatedly except changing Arg3 with each iteration
## ....originally meant to be run with ~/src/R_scripts/simple-barplot_for_Sylvain-output_with_CMD_interface.R
## example of how to run:::    ~/src/shell_script/passing_args_and_running_R.sh file-to-analyze.txt

##  Arg3 will be pulled from another file where each line is a new Arg3
#  Rscript ~/src/R_scripts/simple-barplot_for_Sylvain-output_with_CMD_interface.R "temp-GFP-and-mCherry-thres__A-D.txt" "D - 10" "D - 09" "InCell" "1" 
## where Arg1 is the file to be read, Arg2 or "D - 10" is the control and Arg3 is the experimental which will be varied.  for more information see the R script

# can put 'time' in front of a command to time how long it takes
OLD_IFS=$IFS
IFS=$'\n'
for i in $(cat uniq_wells.txt); # Loops through the 'master' file one line (e.g. DNA transposon) at a time
	do Rscript ~/src/R_scripts/simple-barplot_for_Sylvain-output_with_CMD_interface.R $1 "D - 03" "$i" "InCell2ndplate" "1";
	sleep 3; # Maybe could use the wait command...also see the basename command
done
IFS=$OLD_IFS  # I think default should be IFS=$' \t\n'
###   http://www.unixcl.com/2009/12/bash-cat-command-space-issue-explained.html

# Rscript ~/src/R_scripts/simple-barplot_for_Sylvain-output_with_CMD_interface.R "temp-GFP-and-mCherry-thres__A-D.txt" "D - 10" "D - 09" "InCell" "1" 
