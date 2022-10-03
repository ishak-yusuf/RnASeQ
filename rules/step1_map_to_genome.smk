container:"docker://condaforge/mambaforge"

if  config["end"] == "paired":

    rule hisat2_alignment:
        output:
            "step1/{sample}.sam",
        params:
            ref=config["gen"],
            strandness=config["ext"]["strandness"],
            f1=config["ext"]["f1"],
            f2=config["ext"]["f2"],
            i="input/",
        threads: config["th"]["normal"]
        message:
            "--- Alignment with Hisat"
        log:
            "step1/{sample}.log",
        resources:
            mem_gb=16,
        conda:
            "envs/align.yaml"
        shell:"""
            hisat2 -q --rna-strandness {params.strandness} -x {params.ref} \
            -1 {params.i}{wildcards.sample}{params.f1} -2 {params.i}{wildcards.sample}{params.f2} -p {threads}\
            -S {output}
            """
elif config["end"] == "single":

    rule hisat2_alignment:
        output:
            "step1/{sample}.sam",
        params:
            ref=config["gen"],
            strandness=config["ext"]["strandness"],
            f=config["ext"]["f"],

        threads: config["th"]["normal"]
        message:
            "--- Alignment with Hisat"
        log:
            "step1/{sample}.log",
        resources:
            mem_gb=16,
        conda:
            "envs/align.yaml"
        shell:"""
            hisat2 -q --rna-strandness {params.strandness} -x {params.ref} \
            -U {params.i}{wildcards.sample}{params.f}  -p {threads}\
            -S {output}
            """


rule bams:
    input: "step1/{sample}.sam"
    output: "step1/{sample}.sorted.bam"
    threads: config["th"]["normal"]
    conda: "envs/align.yaml"
    params: "step1"
    shell: """
        samtools view -@ {threads} -bh {input} > {params}{wildcards.sample}.bam
        rm {input}
        samtools sort -@ {threads} {params}{wildcards.sample}.bam > {output}
        rm {params}{wildcards.sample}.bam
        """


