container: "docker://condaforge/mambaforge"


rule kallisto:
    input:
        metadata="input/meta/{sample}",
    output:
        "Step2T/{sample}",
    conda:
        "envs/kallisto.yaml"
    script:
        "scripts/kallisto.R"
