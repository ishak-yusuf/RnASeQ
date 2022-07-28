# put all fastq in the Directory 
# the assumption is that the fastq files are r_1.fq.gz, f_2.fq.gz
for i in $ls *1.fq.gz; 
 do 
 sam=${i//_1.fq.gz/.sam} 
 fq2=${i//_1.fq.gz/_2.fq.gz} 
 sbam=${i//_1.fq.gz/.sorted.bam} 
 
 echo "===Alignment with hisat====" 
 source /home/genwork1/anaconda3/etc/profile.d/conda.sh 
 conda activate refhg38_hisat2 
 hisat2 -x hg38 -1 ${i} -2 ${fq2} -S ${sam} -p 20 
 
 echo "=======Bam works===========" 
 samtools view -@ 20 -b ${sam} | samtools sort -@ 20 -O bam -o ${sbam} 
 samtools index ${sbam} 
 rm ${sam} 
 echo "====the bam step is done========" 
 done 
