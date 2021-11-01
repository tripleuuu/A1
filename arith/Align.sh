#!/bin/bash
#This script is for obtaing the result of alignment
#1 set up the index
mkdir samindex
cd ./samindex
bowtie2-build -f "../Tcongo_genome/TriTrypDB-46_TcongolenseIL3000_2019_Genome.fasta.gz" Tcongo
cd ..

#2 align
if [ "$l" = "all" ]; then
mkdir ./ali_output/$i/$var1
 for name in ./interfile/pair$var1.1
 do
 cut -c -14 $name
 bowtie2 -x ./samindex/Tcongo -1 ./fastq/{$name}1.fq.gz -2 ./fastq/{$name}2.fq.gz -S ./ali_output/$i/$var1/alignment$var1.sam
 done
#3 convert the alignment.sam in .bam files
samtools view -bS ./ali_output/$i/$var1/alignment$var1.sam > ./ali_output/$i/$var1/alignment$var1.bam

#4 sort and index the alignment.bam
samtools sort ./ali_output/$i/$var1/alignment$var1.bam > ./ali_output/$i/$var1/alignment$var1.sorted.bam
mkdir ./opsamindex/$i/$var1
cp ./ali_output/$i/$var1/alignment$var1.sorted.bam ./opsamindex/$i/$var1
cd ./opsamindex/$i/$var1
samtools index alignment$var1.sorted.bam 
cd ..
cd ..

echo "Wait for the output."
#generate the number of aligned pair that codes genes
#I intersect between alignment.sorted.bam and TriTrypDB-46_TcongolenseIL3000_2019.bed
bedtools intersect -a TriTrypDB-46_TcongolenseIL3000_2019.bed -b ./ali_output/$i/$var1/alignment$var1.sorted.bam -wa -wb -bed  > ./ali_output/$i/$var1/overlap$var1.bed
#find sequences coding genes and genetate the result
#assume that keywords 'unspecified product' indicate the non-coding gene
echo "Name: $i,$var1 /n" >./ali_output/$i/$var1/num_of_coding.txt 
cat ./ali_output/$i/$var1/overlap$var1.bed | grep -v "unspecified product" | wc -l >> ./ali_output/$i/$var1/num_of_coding.txt
cat ./ali_output/$i/*/*.txt >> num_of_coding$i.txt 
else
mkdir ./ali_output/$i/$l
 for name in ./interfile/pair$l.1
 do
 cut -c -14 $name
 bowtie2 -x ./samindex/Tcongo -1 ./fastq/{$name}1.fq.gz -2 ./fastq/{$name}2.fq.gz -S ./ali_output/$i/$l/alignment$l.sam
 done
#3 convert the alignment.sam in .bam files
samtools view -bS ./ali_output/$i/$l/alignment$var1.sam > ./ali_output/$i/$l/alignment$l.bam

#4 sort and index the alignment.bam
samtools sort ./ali_output/$i/$l/alignment$var1.bam > ./ali_output/$i/$l/alignment$l.sorted.bam
mkdir ./opsamindex/$i/$l
cp ./ali_output/$i/$l/alignment$l.sorted.bam ./opsamindex/$i/$l
cd ./opsamindex/$i/$l
samtools index alignment$l.sorted.bam
cd ..
cd ..
echo "Wait for the output."
bedtools intersect -a TriTrypDB-46_TcongolenseIL3000_2019.bed -b ./ali_output/$i/$l/alignment$l.sorted.bam -wa -wb -bed  > ./ali_output/$i/$l/overlap$l.bed
#find sequences coding genes and genetate the result
echo "Name: $i,$l /n" >./ali_output/$i/$l/num_of_coding.txt 
cat ./ali_output/$i/$l/overlap$l.bed | grep -v "unspecified product" | wc -l >> ./ali_output/$i/$l/num_of_coding.txt
cat ./ali_output/$i/*/*.txt >> num_of_coding$i.txt
echo "Alignment has been done."

