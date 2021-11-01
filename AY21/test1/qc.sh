#!/bin/bash
#check the quality
#output results into the certain directory
mkdir ./qc_output

#assume all the files required in the directory "./fastq“
if [ "$l" = "all" ]; then
do
mkdir ./qc_output/$i/$var
 while read fqc1 
 do
 fastqc ./fastq/$fqc1 -o ./fastq_output/$i/$var
 done < ./interfile/pair$var.*

#unzip
 for file1 in ./fastq_output/$i/$var/*.zip
 do
 unzip $file1 -d ./fastq_output/$i/$var
 done

#output the information
 echo "What information do you want? 
 def = Filename& Total Sequences& quality
 sum = consolidate of all 'summary.txt'
 data = consolidate of all 'fastqc_data.txt'
 other keyword (one word please) "
 read
  for inf1 in $REPLY
   if [ "$inf1" = "def" ]; then
   do
   cat ./fastq_output/$i/$var/*/fastqc_data.txt | egrep "Filename|Total Sequences|quality" > fastqc_def{$i}$var.txt
   elif [ "$inf1" = "sum" ]; then
   do
   cat ./fastq_output/$i/$var/*/summary.txt > fastqc_sum{$i}$var.txt
   elif [ "$inf1" = "data" ]; then
   do
   cat ./fastq_output/$i/$var/*/fastqc_data.txt > fastqc_data{$i}$var.txt
   else 
   do
   cat ./fastq_output/$i/$var/*/fastqc_data.txt | grep "$inf1" > fastqc_{$inf1}{$i}$var.txt
   fi
  done 
 echo "information has been output"
else 
do
mkdir ./qc_output/$i/$l
 while read fqc2
 do
 fastqc ./fastq/$fqc2 -o ./fastq_output/$i/$l
 done < ./interfile/pair$l.*
#unzip
 for file2 in ./fastq_output/$i/$l/*.zip
 do
 unzip $file2 -d ./fastq_output/$i/$l
 done

#output the information
 echo "What information do you want?
 def = Filename& Total Sequences& quality
 sum = consolidate of all 'summary.txt'
 data = consolidate of all 'fastqc_data.txt'
 other keyword (one word please) "
 read
  for inf1 in $REPLY
   if [ "$inf1" = "def" ]; then
   do
   cat ./fastq_output/$i/$l/*/fastqc_data.txt | egrep "Filename|Total Sequences|quality" > fastqc_def{$i}$l.txt
   elif [ "$inf1" = "sum" ]; then
   do
   cat ./fastq_output/$i/$l/*/summary.txt > fastqc_sum{$i}$l.txt
   elif [ "$inf1" = "data" ]; then
   do
   cat ./fastq_output/$i/$l/*/fastqc_data.txt > fastqc_data{$i}$l.txt
   else
   do
   cat ./fastq_output/$i/$l/*/fastqc_data.txt | grep "$inf1" > fastqc_{$inf1}{$i}$l.txt
   fi
  done
 echo "information has been output"
done 


