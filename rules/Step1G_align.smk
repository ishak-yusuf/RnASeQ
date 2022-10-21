container: "docker://condaforge/mambaforge"


if config["end"] == "paired":

    rule hisat2_alignment:
        output:
            "Step1G/{sample}.sam",
        params:
            ref=config["indexname"],
            strandness=config["ext"]["strandness"],
            f1=config["ext"]["f1"],
            f2=config["ext"]["f2"],
            i="input/",
            a="Assembly/",
        threads: config['th']['normal']
        message:
            "--- Alignment paired genome with Hisat"
        log:
            "Step1G/{sample}.sam.log",
        conda:
            "envs/align.yaml"
        shell:
            """
            hisat2 -q --rna-strandness {params.strandness} -x {params.a}{params.ref} \
            -1 {params.i}{wildcards.sample}{params.f1} -2 {params.i}{wildcards.sample}{params.f2} -p {threads}\
            -S {output} 2> {log}
            """


elif config["end"] == "single":

    rule hisat2_alignment:
        output:
            "Step1G/{sample}.sam",
        params:
            ref=config["indexname"],
            strandness=config["ext"]["strandness"],
            f=config["ext"]["f"],
            i="input/",
            a="Assembly/",
        threads: workflow.cores 
        message:
            "--- Alignment single genome with Hisat"
        log:
            "Step1G/{sample}.log",
        conda:
            "envs/align.yaml"
        shell:
            """
            hisat2 -q --rna-strandness {params.strandness} -x {params.a}{params.ref} \
            -U {params.i}{wildcards.sample}{params.f}  -p {threads}\
            -S {output} 2> {log}
            """

rule bams:
    input:
        "Step1G/{sample}.sam",
    output:
        "Step1G/{sample}.sorted.bam",
    threads: config['th']['normal']
    conda:
        "envs/align.yaml"
    params:
        "Step1G/",
    shell:
        """
        samtools view -@ {threads} -bh {input} > {params}{wildcards.sample}.bam
        rm {input}
        samtools sort -@ {threads} {params}{wildcards.sample}.bam > {output}
        rm {params}{wildcards.sample}.bam
        """
