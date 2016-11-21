# bzip2 -dk /Volumes/LabDataCopy/LabData/SHARED_DATA/modENCODE_ChIPSeq/batch_run/Solexa_Elate8_SU\(VAR\)3-9_Q2598.2487.fastq.bz2

# ./bowtie -t -q -a -v 0 /Volumes/LabDataCopy/LabData/SHARED_DATA/modENCODE_ChIPSeq/batch_run/d_melanogaster_top_repeats_plus /Volumes/LabDataCopy/LabData/SHARED_DATA/modENCODE_ChIPSeq/batch_run/Solexa_Elate8_SU\(VAR\)3-9_Q2598.2487.fastq >/Volumes/LabDataCopy/LabData/SHARED_DATA/modENCODE_ChIPSeq/batch_run/Solexa_Elate8_SU\(VAR\)3-9_Q2598.2487.top_repeats_plus

# perl /Volumes/LabDataCopy/LabData/SHARED_DATA/Serafin/ChIPSeq_reshear/grep.pl /Volumes/LabDataCopy/LabData/SERAFIN/modENCODE_files/Solexa_Elate8_SU\(VAR\)3-9_Q2598.2487.top_repeats_plus

import os
import subprocess as SP
############ below is the name and path of the directory to look for files and the index file name which should be in the same directory
directory = './batch_run/'
i_file_name = 'd_melanogaster_top_repeats_plus'
grep_loc = '/Volumes/LabDataCopy/LabData/SHARED_DATA/Serafin/ChIPSeq_reshear/grep.pl'

aa = os.listdir(directory) # list of files in the directory

program = 'bzip2'
prog1 = '/Volumes/LabDataCopy/LabData/SERAFIN/ChIPSeq/bowtie-0.12.7/bowtie'
indx_file = directory + i_file_name
prog2 = 'perl'

for x,i in enumerate(aa):  ## x is the counter, i is the item being iterated thru (name of a file)
	full_name = directory + i # this is the path to the file with the file name
	if i.count('fastq'): # if files contains bz2 then do what is in this if statement
		print i
# 		cmd = [program, '-dk', full_name]
# 		uzip = SP.Popen(cmd)
# 		uzip.wait() # Allows the program to finish
		print full_name
		fastq_fn = full_name[:]
		print fastq_fn
		rpt_outp = full_name[:-6] + '.top_repeats_plus'
		print rpt_outp
		# try to do SP.Popen(touch) to create the bowtie output file and then when running the bowtie command change the stdout to the file I created or use SP.PIPE and then communicate() and then open
		cmd1 = [prog1, '-t', '-q', '-a', '-v 0', indx_file, fastq_fn] #, '>', rpt_outp]
		rptfh = open(rpt_outp,'w') #this line and line below creates a blank output file for bowtie to write to
		btierun = SP.Popen(cmd1, stdout = rptfh, stderr = SP.PIPE)
		rptfh.close()
		#### I not only need to generate the output file by capturing it using '>', but I also need to report the # of reads processed which is currently at 2> .  I think this might be STDOUT and STDERR
		btierun.wait() # Allows the program to finish
		bb = btierun.communicate() #this returns a tuple
		print bb
		loc_rp = list(bb)[1].index('reads process')  #this converts the tuple to a list, looks at the first element and then returns the index in that element that contains "reads process"
		ndx2 = list(bb)[1].index('reads with at least one reported alignment')
		rs_proc = list(bb)[1][loc_rp:ndx2-4]  ## saves the 'reads processed' to a variable
						      #btieout = btierun.stdout.readlines()
		cmd2 = [prog2, grep_loc, rpt_outp]
		grepout = rpt_outp + ".grepified"
		grepfh = open(grepout,'w') #this line and line below creates a blank output file for grep to write to
		
		line1 = rs_proc.split(':')
		line2 = '\t'.join(line1)
		grepfh.write(line2)
		greprun = SP.Popen(cmd2, stdout = grepfh)
		greprun.wait()
		print rs_proc
		print
		print
		print
	else:
		print "not found"
print "Finished with all .bz2 files......you may want to delete the unzipped version now"


'''
for x,i in enumerate(aa):
    aa[x]='./S7.2/index3/'+i
    if i.count('index3'):
        continue
    else:
        print "something other than index3 found was found in the reads"
        break
read_files = ','.join(aa)
index_file = './S6.2/E_coli_index'
program = 'tophat'
###tophat --no-novel-juncs -G ~/PythonCourse/data/dmel-4-transcripts-r5.38.gtf -o reads12 dmel-r5_38 reads_1_1,reads_2_1 reads_1_2,reads_2_2
####### Could use raw input to get these options
opt1 = '--no-novel-juncs -G ~/PythonCourse/data/dmel-4-transcripts-r5.38.gtf'  ## This option tells tophat these are the gene models
outp = 'tophat_output_7.2'
print program, '-o', outp, index_file, read_files
cmd = [program,'-o', outp, index_file, read_files]
#print SP.Popen(['which','tophat'],stdout=SP.PIPE).communicate()
#print SP.Popen(['echo','$PATH'],stdout=SP.PIPE).communicate()
SP.Popen(cmd)
'''


'''
# some arguments for running BLAST
program = 'blastn'
queryseq = 'query.fasta'
database = 'yeast.nt'
evalu = str(1e-08)
cmmnt = str(6)
 
# open a filehandle for our output file, we'll use the append flag in case
# we want to collect multiple queries worth of output
 
 
proc = SP.Popen([program, '-query', queryseq, '-db', database, '-evalue', evalu, '-outfmt', cmmnt], stdout=SP.PIPE)  ###-outfmt 7 gives output in a tabular format with comments
output = proc.communicate()
outlist = output[0].split('\n')  ### Now I have a list where every item in the list is a tab sererated line
dct = {}
for entr in outlist:
    if entr == '':
        print "empty element"
        break
    o1 = entr.split('\t')
    dct[o1[1]] = [o1[3],o1[10],o1[2]]  # containing the length of the hit, the E-value, and the percent identity of the hit.

print dct
'''





