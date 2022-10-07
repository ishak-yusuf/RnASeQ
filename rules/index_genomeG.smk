if config ['IndexAssembly'] == 'hisat2':
        container:"docker://condaforge/mambaforge"
        rule hisat2_index:
                input: genome = config["Assembly"] 
                params: name= config["indexname"]
                conda: "envs/align.yaml"
                threads: config['th']['max']
                shell: """
                       hisat2-build -p {threads} {input.genome} {params.name}
                       mv *ht2 Assembly
                       """

