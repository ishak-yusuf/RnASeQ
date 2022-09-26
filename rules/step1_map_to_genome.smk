rule hisat2_alignment:
    output:
        "stap2/{sample}.sorted.bam"
    params:
        ref="genome",
        strandness="FR"
        f1= config ['ext'] ['f1']
        f2= config ['ext'] ['f2']
        i= "input/"
    threads: 10
    message:
        "--- Alignment with Hisat"
    log:
        "output/{sample}.log",
    resources:
        mem_gb=16

    container: "docker://dceoy/hisat2"
    shell:"""
        hisat2 -q --rna-strandness {params.strandness} -x {params.ref} \
        -1 {params.i}{params.f1} -2 {params.i}{params.f2} -p {threads} \
        | samtools sort -o {output} 2> {log}
        """

