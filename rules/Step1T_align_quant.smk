container: "docker://condaforge/mambaforge"


if config["end"] == "paired":

    rule salmon_alignmant:
        output:
            directory("Step1T/{sample}"),
        params:
            ref=config["indexname"],
            strandness=config["ext"]["strandness"],
            f1=config["ext"]["f1"],
            f2=config["ext"]["f2"],
            i="input/",
            a="Assembly/",
        threads: config["th"]["normal"]
        message:
            "--- Alignment paired genome with Hisat"
        log:
            "Step1T/{sample}.log",
        resources:
            mem_gb=16,
        conda:
            "envs/align.yaml"
        shell:
            """
            kallisto quant -i {params.a}{params.ref} -o {wildcards.sample} \
            {params.i}{wildcards.sample}{params.f1}  {params.i}{wildcards.sample}{params.f2} \
            -t {threads} 2> {log}
            """


elif config["end"] == "single":

    rule salmon_alignmant:
        output:
            directory("Step1T/{sample}"),
        params:
            ref=config["indexname"],
            f=config["ext"]["f"],
            i="input/",
            a="Assembly/",
        threads: config["th"]["normal"]
        message:
            "--- Alignment paired transcriptome with salmon"
        conda:
            "envs/align.yaml"
        shell:
            """
            kallisto quant -i {params.a}{params.ref} -o {wildcards.sample}\
            -t {threads} {params.i}{wildcards.sample}{params.f} &> HS01.log
            """
