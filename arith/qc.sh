#!/bin/bash
#This script is for obtaing the result of quality check by fastqc
#check the quality
#output results into the certain directory
mkdir ./qc_output

#assume all the files required in the directory "./fastq“
if [ "$l" = "all" ]; then
mkdir ./qc_output/$i/$var1
 while read fqc1 
 do
 fastqc ./fastq/$fqc1 -o ./qc_output/$i/$var1
 done < ./interfile/*pair$var1

#unzip
 for file1 in ./qc_output/$i/$var1/*.zip
 do
 unzip $file1 -d ./qc_output/$i/$var1
 done

#output the information
 echo "What information do you want? 
 def = Filename& Total Sequences& quality
 sum = consolidate of all 'summary.txt'
 data = consolidate of all 'fastqc_data.txt'
 other keyword (one word please) "
 read
  for inf1 in $REPLY
  do
   if [ "$inf1" = "def" ]; then
   cat ./qc_output/$i/$var1/*/fastqc_data.txt | egrep "Filename|Total Sequences|quality" > fastqc_def{$i}$var1.txt
   elif [ "$inf1" = "sum" ]; then
   cat ./qc_output/$i/$var1/*/summary.txt > fastqc_sum{$i}$var1.txt
   elif [ "$inf1" = "data" ]; then
   cat ./qc_output/$i/$var1/*/fastqc_data.txt > fastqc_data{$i}$var1.txt
   else 
   cat ./qc_output/$i/$var1/*/fastqc_data.txt | grep "$inf1" > fastqc_{$inf1}{$i}$var1.txt
   fi
  done 
 echo "information has been output"
else 
mkdir ./qc_output/$i/$l
 while read fqc2
 do
 fastqc ./fastq/$fqc2 -o ./qc_output/$i/$l
 done < ./interfile/*pair$l
#unzip
 for file2 in ./qc_output/$i/$l/*.zip
 do
 unzip $file2 -d ./qc_output/$i/$l
 done

#output the information
 echo "What information do you want?
 def = Filename& Total Sequences& quality
 sum = consolidate of all 'summary.txt'
 data = consolidate of all 'fastqc_data.txt'
 other keyword (one word please) "
 read
  for inf1 in $REPLY
  do
   if [ "$inf1" = "def" ]; then
   cat ./qc_output/$i/$l/*/fastqc_data.txt | egrep "Filename|Total Sequences|quality" > fastqc_def{$i}$l.txt
   elif [ "$inf1" = "sum" ]; then
   cat ./qc_output/$i/$l/*/summary.txt > fastqc_sum{$i}$l.txt
   elif [ "$inf1" = "data" ]; then
   cat ./qc_output/$i/$l/*/fastqc_data.txt > fastqc_data{$i}$l.txt
   else
   cat ./qc_output/$i/$l/*/fastqc_data.txt | grep "$inf1" > fastqc_{$inf1}{$i}$l.txt
   fi
  done
fi
 echo "Information of quality check has been output." 


