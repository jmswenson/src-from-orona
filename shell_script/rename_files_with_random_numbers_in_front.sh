for fname in *.dv
do
echo mv "$fname" ${RANDOM}_js.dv${fname}.dv
#mv "$fname" ${RANDOM}_js.dv${fname}.dv
done
# If you are trying to blindly rename files I suggest doing the following as well
# First make sure you didn't get really unlucky and pick the same random number twice by
# Next, make sure that those are the only files in the directory that start with a number (otherwise you have to modify the below)
# ls [0-9]*|cut -f1 -d'_'|sort -u|wc -l should be the same as ls[0-9]*|wc -l (unless there are files in the directory that start with a number AND don't have an underscore...maybe)
# ls [0-9]*>key.txt #to make a key
###### Note, run below command below with the echo in before the mv to make sure it is behaving properly and then remove the echo to do the damage
###### change 121515 to a pattern that matches your files
# for file in [0-9]*; do echo mv "${file}" "${file/121515*/}"; done   # to get rid of non-random part of filename where 121515 is the start of your real filename

