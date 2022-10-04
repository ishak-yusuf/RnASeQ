container:"docker://condaforge/mambaforge"

if config["end"] == "paired" and config["map"] == "genome":

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
            "--- Alignment paired genome with Hisat"
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

elif config["end"] == "single" and config["map"] == "genome":

    rule hisat2_alignment:
        output:
            "step1/{sample}.sam",
        params:
            ref=config["gen"],
            strandness=config["ext"]["strandness"],
            f=config["ext"]["f"],

        threads: config["th"]["normal"]
        message:
            "--- Alignment single genome with Hisat"
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

elif config ["end"] == "paired" and config ['map'] =="transcriptome":
    rule salmon_alignmant:
        output: quant_dir=  directory("stetp1/{sample}")
        params:
            ref=config["gen"],
            strandness=config["ext"]["strandness"],
            f=config["ext"]["f"]
        threads: config["th"]["normal"]
        message:
            "--- Alignment paired transcriptome with salmon"
        conda: "envs/align.yaml"
        shell:"""
            salmon quant -i {params.ref} -l A -1 {params.i}{wildcards.sample}{params.f1} \
            -2 {params.i}{wildcards.sample}{params.f2} \
            -o {output.quant_dir} -p {thread} --seqBias --useVBOpt --validateMappings
            """

elif config ["end"] == "single" and config ['map'] =="transcriptome":
    rule salmon_alignmant:
        input:
        output:
        message:
            "--- Alignment single transcriptome with salmon"
        conda: "envs/align.yaml"
        shell:


















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


