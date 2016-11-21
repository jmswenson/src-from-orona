#!/usr/bin/env python
# run script like: python ~/src/python/match_screen_names_to_data.py assay*robust*csv
### This script reads in the 'Cherrypick' file which matches the plate and well to the gene.  It creates a dictionary using this information.
### Next the data file generated from the image analysis and my R-script is read in.  I output this data file with information about which gene is in which well
## before running this script needed to clean up line feeds on the 'Cherrypick' file (^M) by using ~/src/perl/fix_Mascot_linefeeds.pl.  Also might have to get rid of excess headers if you cat'd files together.  Finally, might have to add column title "date_added" at the end of the first header
## This script also names the controls properly based on which well they were in


import sys
fh = open("fixed_line_feeds_Cherrypick_Joe_Swenson_96-well_assay_plates.tab.txt", 'r') #....current argument is  ~/secondary_screen_images/fixed_line_feeds_Cherrypick_Joe_Swenson_96-well_assay_plates.tab.txt

fh.readline() ## skips the header line

wellinfo={}  ### this will be a dictionary where the key is the plate name
             ### combined with the well name (column10 fused to column11) and the value is a list of gene,amplicon,assayplatecontent (3,2,12)
for line1 in fh:
    #    print line1
    #    ln = line1#.strip()
    line = line1.split('\t')  ### Want column 2,3, 10,11, and 12 (only 12 if 2 and 3 are empty)
                              # NOTE THAT SINCE I DIDN'T STRIP THE LINE (TO PRESERVE WHITESPACE AND PROPER NUMBERING) THERE IS A '\n' at the end of the list
    #    templist = []
    templist = [line[10],line[11]]
    #### Give controls a name
    if line[11].find('B04')>-1 or line[11].find('G07')>-1 or line[11].find('H11')>-1:
        line[12]='HP1a'
        line[2]='HP1a'
        line[3]='HP1a' 
    if line[11].find('B09')>-1 or line[11].find('D06')>-1 or line[11].find('H01')>-1:
        line[12]='SuVar3-9'
        line[2]='SuVar3-9'
        line[3]='SuVar3-9'
    if line[11].find('D08')>-1 or line[11].find('C02')>-1 or line[11].find('G04')>-1 or line[11].find('A06')>-1 or line[11].find('G12')>-1:
        line[12]='THREAD'
        line[2]='THREAD'
        line[3]='THREAD' 
    if line[11].find('A01')>-1 or line[11].find('F02')>-1 or line[11].find('B07')>-1 or line[11].find('E09')>-1:
        line[12]='LacZ'
        line[2]='LacZ'
        line[3]='LacZ' 
    if line[11].find('A11')>-1:
        line[12]='Brown'
        line[2]='Brown'
        line[3]='Brown' 
    if line[11].find('E03')>-1:
        line[12]='Empty'
        line[2]='Empty'
        line[3]='Empty' 
    if line[11].find('D01')>-1 or line[11].find('F05')>-1 or line[11].find('C12')>-1:
        line[12]='GFP'
        line[2]='GFP'
        line[3]='GFP' 
    identinfo = '--'.join(templist)  #identinfo = '--'.join([line[10],line[11]])  #should also work
    wellinfo[identinfo] = [line[3],line[2],line[12]]  ## stored as JS_Assay1--G11
fh.close()
'''
print
print
print
keys = wellinfo.keys()
values = wellinfo.values()
#print keys
for x in keys:
    print 'The key is', x, 'and the value is',wellinfo[x]
'''
for x,file in enumerate(sys.argv):
    if x<1:continue
    xx = sys.argv[x]
    fh1 = open(xx, 'r') #is [1] because it skips the python script name....
    outp = open(xx+'_with_names.tab.txt','w')
    header = fh1.readline().strip().split(',')## prints the header line
    header.append('Gene')
    header.append('Amplicon')
    header.append('Type')
    outp.write('\t'.join(header))
### FIND PLATENAME COLUMN AND WELLNAME COLUMN IN DATA FILE
    print file
    plindex = header.index('plate_name')
    wlindex = header.index('well_name')
    for line1 in fh1:
        line1 = line1.strip()
        line = line1.split(',')  ### Want column 2,3, 10,11, and 12 (only 12 if 2 and 3 are empty)
                              # NOTE THAT SINCE I DIDN'T STRIP THE LINE (TO PRESERVE WHITESPACE AND PROPER NUMBERING) THERE IS A '\n' at the end of the list...could easily eliminate if needed
        platenwell = [line[plindex],line[wlindex]] #stored as ['assay4','G01']
    #platenwell = [line[-3],line[-2]] #stored as ['assay4','G01']
        temp = '--'.join(platenwell)
        tofetch = 'JS_A'+temp[1::]  # adds JS to the front and changes the lower case a to an upper case a
                                #pdata = '\t'.join(line)
                                #    print type(line)
                                #print type(wellinfo[tofetch])#
        line.append(wellinfo[tofetch][0])
        line.append(wellinfo[tofetch][1])
        line.append(wellinfo[tofetch][2])
        line.append('\n')
        outp.write('\t'.join(line))
    fh1.close()
    outp.close()


'''
#identify components of the list
keys = wines.keys()
values = wines.values()
print keys
print values
print
 
#iterate over keys
for x in keys:
    print 'The category is', x, 'and the varietal is', wines[x]
print
 
#sort keys and iterate over keys
keys.sort()
for x in keys:
    print 'The category is', x, 'and the varietal is', wines[x]
print
 
#find if something is stored
if 'red' in wines: print wines['red']
print
'''

