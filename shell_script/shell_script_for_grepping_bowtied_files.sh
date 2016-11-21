## This is a short unix script for processing ChIP-seq experiments, particularly if you want to align your results to an index other than the reference genome (e.g. DNA transposons).
## This script will determine how many reads bowtie aligned to a particular sequence.

# Simply change the names below and then copy and paste it to the command line

cat JS001*DNAtransposon.txt>all--DNAtransposons.txt # First combine all your bowtie output files from a particular alignment
cut -f3 all--DNAtransposons.txt |sort -u> all_DNAtransposons.txt # Next take any DNA transposon that mapped to at least one read and put it in a master file
rm all--DNAtransposons.txt # Remove this file


for j in $(ls JS001*_DNAtransposon.txt); # Finds all bowtie output files for a particular alignment and loops through them
do printf '\n';
printf '\n';
echo $j;
for i in $(cat all_DNAtransposons.txt); # Loops through the 'master' file one line (e.g. DNA transposon) at a time
do echo -n $i;
printf '\t';
grep -c $i $j; # Counts how many time the transposon ($i) appears in the bowtie output ($j)
done;
done>counted--DNAtransposons.txt;

