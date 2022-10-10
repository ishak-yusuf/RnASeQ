container: "docker://condaforge/mambaforge"


rule kallisto:
    input:
        metadata="input/{sample}",
    output:
        "Step2T/{sample}",
    conda:
        "envs/kallisto.yaml"
    script:
        "scripts/kallisto.R"
