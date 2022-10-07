if config ['index'] == 'hisat2':
        rule indexGenome:
                input: genome = config["Assembly"]
                output: indexes = directory("indexes"),
                params: config["indexname"]
                threads: config['th']['max']
                shell: "mkdir {output.indexes} && hisat2-build -p {threads} {input.genome} Assembly/{params}"


else:
        pass




