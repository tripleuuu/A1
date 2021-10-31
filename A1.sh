#!/bin/bash
#step1: check the quality of each group
#1.1 obtain the list of group and filename
#1.1.1 give me some information
echo -n "What's the name of your group? (Please use space as delimiter) "
mkdir interfile
read
for i in $REPLY
do
cat ./fastq/100k.fqfiles | grep "$i" > ./interfile/$i.st1
done

#1.1.2 find the corresponding files
echo "Which result(s) do you want? ('all' for all group; keyword(s) for certain group(s). Please use space as delimiter) "
read
for l in $REPLY
do
 if [ "$ans" = "all" ]; then
  echo "Well done!"
 else
 cat *.st1 | grep "$l" | while read line
  do
  cut -f 1,4- > ./interfile/$l.st2
  done
 fi
done



mkdir ./fastq_output
echo "Which result(s) do you want? ('all' for all group; keyword(s) for certain group(s). Please use space as delimiter) "
read
for ans in $REPLY
do
grep "$l" | while read line
do

fastqc ./fastq/*.fq.gz -o ./fastq_output

#1.2 unzipping the outputs of step1.1
for file in ./fastq_output/*.zip
do
unzip $file -d ./fastq_output
done

#step2: assess the numbers and quality of output1
#2.1 Consolidate all output results into one file
echo "These're brief results of the sequence:" > fastqc_summaries.txt
cat ./fastq_output/*/fastqc_data.txt | egrep "Filename|Total Sequences|quality" >> fastqc_summaries.txt

#2.2 Check the resulets with "FAIL" and "WARN"
echo "Here're results with 'FAIL' or 'WARN':" >> fastqc_summaries.txt
cat ./fastq_output/*/summary.txt | egrep "FAIL|WARN" >> fastqc_summaries.txt

#2.3 check more information of each file
echo "More information on their qualities is as follows." >> fastqc_summaries.txt
cat ./fastq_output/*/summary.txt >> fastqc_summaries.txt

#step3: align the read pairs to the genome 
#3.1 set up the index
mkdir samindex
cd ./samindex
bowtie2-build -f "../Tcongo_genome/TriTrypDB-46_TcongolenseIL3000_2019_Genome.fasta.gz" Tcongo
cd ..

#3.2 align
bowtie2 -x ./samindex/Tcongo -1 ./fastq/*_1.fq.gz -2 ./fastq/*_2.fq.gz -S alignment.sam

#3.3 convert the alignment.sam in .bam files
samtools view -bS alignment.sam > alignment.bam 

#3.4 sort and index the alignment.bam
samtools sort alignment.sam > alignment.sorted.bam
samtools index alignment.sorted.bam

#step4: generate counts data as requirement
#4.1 intersect between alignment.sorted.bam and TriTrypDB-46_TcongolenseIL3000_2019.bed
bedtools intersect -a alignment.sorted.bam -b TriTrypDB-46_TcongolenseIL3000_2019.bed -wa -wb -bed > overlap

#find sequences coding genes and genetate the result
echo "The number of which aligned to the gene-coding regions is  " > the_number 
cat overlap | wc -l >> the_number

#step5: output results of expression levels per gene (tab-delimited)
#5.1 convert .bam file to .bed file
bedtools bamtobed -i ./fastq/output2.sorted.bam > convert
