#!/usr/bin/env python
####### Use caution when using this script on huge files because it reads the whole file into memory

######## THIS DOESN'T WORK FOR SOME REASON, THE FILE ISN'T BEING READ IN PROPERLY
import sys
#fh = open(sys.argv[1], 'r') #is [1] because it skips the python script name
fh = open('Cherrypick_Joe_Swenson_96-well_assay_plates.csv', 'r') #is [1] because it skips the python script name

for line1 in fh:
    #line1.replace('\r','\n')  #  replaces  ^M with \n
    print line1
fh.close()
#print type(whole_file)
#whole_file.replace('\r','\n')  #  replaces  ^M with \n
#'\r' is carriage return
#print whole_file

