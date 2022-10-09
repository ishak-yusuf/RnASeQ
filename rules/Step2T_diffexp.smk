container: "docker://condaforge/mambaforge"


rule deseq2:
    input:
        metadata="input/meta/{sample}.csv",
    output:
        "Step2T/{sample}_normalized_table.csv",
    conda:
        "envs/kallisto.yaml"
    script:
        "scripts/kallisto.R"
