container: "docker://condaforge/mambaforge"


rule deseq2:
    input:
        featureCount="Step3G/counts_all.txt",
        metadata="input/meta/{sample}",
    output:
        "Step4G/{sample}_normalized_table.csv",
    conda:
        "envs/deseq2.yaml"
    script:
        "scripts/deseq2.R"
