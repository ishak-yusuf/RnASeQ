if config["IndexAssembly"] == "kallisto":

    container: "docker://condaforge/mambaforge"

    rule kallisto_index:
        input:
            Transcriptome=config["Assembly"],
        params:
            name=config["indexname"],
        conda:
            "envs/align.yaml"
        threads: config["th"]["max"]
        shell:
            """
            kallisto index -i {params.name} {input.Transcriptome}
            mv *{params.name}* Assembly
            """
