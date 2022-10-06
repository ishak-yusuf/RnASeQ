container:"docker://condaforge/mambaforge"

if config ["end"] == "paired":
        rule salmon_alignmant:
                output: quant_dir=  directory("stetp1/{sample}")
                params:
                        ref=config["gen"],
                        strandness=config["ext"]["strandness"],
                        f1=config["ext"]["f1"],
                        f2=config["ext"]["f2"],
                        i="input/",
                threads: config["th"]["normal"]
                message:
                        "--- Alignment paired transcriptome with salmon"
                conda: "envs/align.yaml"
                shell:"""
                        salmon quant -i {params.ref} -l A -1 {params.i}{wildcards.sample}{params.f1} \
                        -2 {params.i}{wildcards.sample}{params.f2} \
                        -o {output.quant_dir} -p {thread} --seqBias --useVBOpt --validateMappings
                        """

elif config ["end"] == "single":
        rule salmon_alignmant:
                output: quant_dir= directory("stetp1/{sample}")
                params:
                        ref=config["gen"],
                        strandness=config["ext"]["strandness"],
                        f=config["ext"]["f"],
                        i="input/",
                threads: config["th"]["normal"]
                message:
                        "--- Alignment paired transcriptome with salmon"
                conda: "envs/align.yaml"
                shell:"""
                        salmon quant -i {params.ref} -l A -r {params.i}{wildcards.sample}{params.f} \
                        -o {output.quant_dir} -p {thread} --seqBias --useVBOpt --validateMappings
                        """