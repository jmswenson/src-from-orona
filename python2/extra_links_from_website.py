
##########   NOTE: THIS IS VERY INCOMPLETE...SEARCH GMAIL FOR WGET and SERAFIN to see how I solved this problem
fh = open('website_source_for_modencode_files.txt', 'r')
outfh = open('csv_list_of_files_for_wget.txt', 'w')

csvlist = []
for line in fh:
    ln = line.strip()
    line1 = line.split('<a href="')
    ndx = line1[1].find('"')
    #print ndx
    if ndx>0:
        csvlist.append(line1[1][:ndx])

csvend = ','.join(csvlist)
print csvend

        #ndx = ln.index('a href=')

        #outfh.write('>'+ln+'\n')
        #outfh.write(l50[1:]+'\n')
fh.close()
outfh.close()




###  Use this on command line after conclusion of python script:  wget -i download-file-list.txt
##   wget -A .bz -P /Volumes/LabDataCopy/LabData/SHARED_DATA/modENCODE_ChIPSeq/ --user=modencode --password=fly -i 'csv_list_of_files_for_wget.txt


##  http://compbio.med.harvard.edu/lucy/fastq/
