rule hisat2_alignment:
    output:
        "step1/{sample}.sorted.bam"
    params:
        ref= config ['gen'],
        strandness="FR",
        f1= config ['ext'] ['f1'],
        f2= config ['ext'] ['f2'],
        i= "input/"
    threads: 10
    message:
        "--- Alignment with Hisat"
    log:
        "step1/{sample}.log",
    resources:
        mem_gb=16

    container: "docker://condaforge/mambaforge"
    conda: "envs/align.yaml"
    shell:"""
        hisat2 -q --rna-strandness {params.strandness} -x {params.ref} \
        -1 {params.i}{wildcards.sample}{params.f1} -2 {params.i}{wildcards.sample}{params.f2} -p {threads} \
        | samtools sort -o {output} 2> {log}
        """
