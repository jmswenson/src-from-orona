# This script allows you to iterate through every subdirectory and run an R script (which was designed to run on a single directory....output will be on a single direcotry too)....may need to use getwd() in R script depending on how I wrote it

import os
import subprocess as SP

aa = os.listdir(os.getcwd()) # list of files in the directory
dirs_only = [x for x in aa if not x.endswith("txt")] # gets rid of anything that ends in "txt" leaving only directories and .RData and .Rhistory
d_only = [x for x in dirs_only if not x.startswith(".")] # gets rid of .RData and .Rhistory

print "Make sure variable new_dir contains only directories"

prog1 = '~/src/R_scripts/format_repeats_for_clustergram--use-on-multiple-dirs.R'
main_path = os.getcwd()
for x in d_only:
	new_dir = main_path + "/" + x
	os.chdir(new_dir)
	print new_dir
	runit = SP.Popen("Rscript --vanilla ~/src/R_scripts/format_repeats_for_clustergram--use-on-multiple-dirs.R", shell = True )
	runit.wait()
