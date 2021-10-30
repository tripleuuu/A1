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
mkdir Tb927genome
cd ./Tb927genome
bowtie2-build -f "/localdisk/home/s2232496/AY21A1/genome.fasta.gz" Tb927

#3.2 specify the path of files 
mkdir Tb927read
cp /localdisk/data.local/BPSM/Assignment1/fastq/*.gz ./Tb927read
cd Tb927read

#3.3 align
bowtie2 -x ../Tb927/Tb927 -1 *_1.fq.gz -2 *_2.fq.gz -S output2.sam

#3.4 convert the output2.sam in .bam files
 
