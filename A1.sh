#!/bin/bash
echo -n "What's the name of your group? (WT/Colon1/Colon2) (Please use space as delimiter) "
mkdir interfile
read
#1.1.1 give me some information
for i in $REPLY
do
cat ./fastq/100k.fqfiles | grep "$i" > ./interfile/$i.st1
done

#1.1.2 find the corresponding files
echo "Which group(s) do you want? ('all' for all group; keyword(s) for certain group(s), Induced,etc. Please use space as delimiter) "
read
for l in $REPLY
do
 if [ "$l" = "all" ]; then
 echo "Please tell me which column(s) the experimental group data is in. (use space as delimiter) "
 read
  for col in $REPLY
  do  
  cat ./interfile/$i.st1 | cut -f $col | uniq | sort > ./interfile/variable$col.st2
   while read var1
    do
    cat ./interfile/$i.st1 | grep "$var1" | cut -f 6 > ./interfile/pair$var1.1
    cat ./interfile/$i.st1 | grep "$var1" | cut -f 7 > ./interfile/pair$var1.2
   done < ./interfile/variable$col.st2
 done
#Here's some changes  
 else     
  cat ./interfile/$i.st1 | grep "$l" | cut -f 6 > ./interfile/pair$l.1
  cat ./interfile/$i.st1 | grep "$l" | cut -f 7 > ./interfile/pair$l.2  
 fi
done

#output the results 
echo "Processing quality check."
source ./arith/qc.sh
echo "Processing alignment."
source ./arith/Align.sh
echo "Processing mean(ie. gene expression)."
source ./arith/mean.sh

echo "Done. Cheers!"
exit 0


