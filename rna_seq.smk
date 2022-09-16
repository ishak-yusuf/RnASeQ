import os

def getlist():
        id_list_fq=[]
        for i in os.listdir():
                #gets list of fastqs:
                if i.endswith('_R1_001.fastq.gz'):
                        id = os.path.basename(i)[:-16]
                        id_list.append(id)
        return id_list_fq



rule all:
        input:
                expand("sample{sample}.sorted.bam", sample= getlist()),
                "counts_all.txt"

rule hisat2_alignment:
        input:  f1= "{sample}_R1_001.fastq.gz",
                f2= "{sample}_R2_001.fastq.gz"
        output: 'sample{sample}.sorted.bam'
        params: ref= '/home/genwork2/Desktop/05.ref_area/ref_hisat2_annhg38p13/GRCh38.p13.genome.fa'
        threads: 10
        message: """--- Alignment with Hisat"""
        log: '{sample}.log'
        resources:
                mem_gb= 20,
                rate_limit=1
        shell: '''
                hisat2 -q --rna-strandness FR -x {params.ref} -1 {input.f1} -2 {input.f2} -p {threads} |\
                samtools sort -o {output} -@ {threads} 2> {log}
        '''

rule featureCounts:
        output: "counts_all.txt"
        params:  gff='/home/genwork2/Desktop/05.ref_area/ref_hisat2_annhg38p13/gencode_annotation.gff3'
        threads: 40
        log: "counts_all.txt.log"
        resources:
                mem_gb= 100
        shell: 'featureCounts  -t exon  -g  exon_name  -a {params.gff} -o counts_all.txt\
          -T {threads} {sample}.sorted.bam 2> {log}'
