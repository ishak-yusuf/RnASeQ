rule hisat2_alignment:
    input:
        f1="{sample}",
        f2="{sample}_R2_001.fastq.gz"
    output:
        "output/{sample}.sorted.bam"
    params:
        ref="genome",
        strandness="FR"
    threads: 10
    message:
        "--- Alignment with Hisat"
    log:
        "output/{sample}.log",
    resources:
        mem_gb=16,
        rate_limit=1,
    conda: "envs/align.yaml"
    shell:
        """
        hisat2 -q --rna-strandness {params.strandness} -x {params.ref} -1 {input.f1} -2 {input.f2} -p {threads} \
        | samtools sort -o {output} 2> {log}
        """