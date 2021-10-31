#!/bin/bash
#step1: check the quality
#1.1 output results into current directory(output1)
fastqc /localdisk/data.local/BPSM/Assignment1/fastq/*.fq.gz -o /localdisk/home/s2232496/AY21A1

#1.2 unzipping the outputs of step1.1
for filename in *.zip
do
unzip $filename 
done

#step2: assess the numbers and quality of output1
#2.1 Consolidate all output results into one file
echo "These're brief results of the sequence:" > fastqc_summaries.txt
cat */fastqc_data.txt | egrep "Filename|Total Sequences|quality" >> fastqc_summaries.txt
echo "More information on their qualities is as follows." >> fastqc_summaries.txt
cat */summary.txt >> fastqc_summaries.txt

#2.2 Check the resulets with "FAIL" and "WARN"
echo "Here're results with 'FAIL' or 'WARN':" >> fastqc_summaries.txt
cat */summary.txt | egrep "FAIL|WARN" >> fastqc_summaries.txt

#step3: align the read pairs to the genome 
#3.1 set up the index
mkdir Tb927index
cd ./Tb927index
bowtie2-build -f "/localdisk/data.local/BPSM/Assignment1/Tbb_genome/Tb927_genome.fasta.gz" Tb927
cd ..

#3.2 align
bowtie2 -x ./Tb927/Tb927 -1 /localdisk/data.local/BPSM/Assignment1/fastq/*_1.fq.gz -2 /localdisk/data.local/BPSM/Assignment1/fastq/*_2.fq.gz -S output2.sam

#3.3 convert the output2.sam in .bam files
samtools view -bS output2.sam > output2.bam 

#3.4 sort and index the output2
samtools sort output2.sam > output2.sorted.bam
samtools index output2.sorted.bam

#step4: generate counts data as requirement
#4.1 intersect between output2.sorted.bam and Tbbgenes.bed
bedtools intersect -a ./fastq/output2.sorted.bam -b /localdisk/data.local/BPSM/Assignment1/Tbbgenes.bed -wa -wb -bed > output3

#find sequences coding genes and genetate the result
echo "The number of which aligned to the gene-coding regions is  " > the_number 
cat output3 | grep -w "gene" | wc -l >> the_number

#step5: output results of expression levels per gene (tab-delimited)
#5.1 convert .bam file to .bed file
bedtools bamtobed -i ./fastq/output2.sorted.bam > convert
