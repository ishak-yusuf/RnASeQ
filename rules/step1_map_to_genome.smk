rule hisat2_alignment:
    output:
        "step1/{sample}.sorted.bam",
    params:
        ref=config["gen"],
        strandness="FR",
        f1=config["ext_hi"]["f1"],
        f2=config["ext_hi"]["f2"],
        i="input/",
    threads: config["th"]["normal"]
    message:
        "--- Alignment with Hisat"
    log:
        "step1/{sample}.log",
    resources:
        mem_gb=16,
    container:
        "docker://condaforge/mambaforge"
    conda:
        "envs/align.yaml"
    shell:
        """
        hisat2 -q --rna-strandness {params.strandness} -x {params.ref} \
        -1 {params.i}{wildcards.sample}{params.f1} -2 {params.i}{wildcards.sample}{params.f2} -p {threads} \
        -S {sample}.sam
        samtools view -S {sample}.sam -@ {threads} -b {sample}.bam
        rm {sample}.sam
        samtools sort -I {sample}.bam  -o {output} -@ {threads} 2> {log}
        """
