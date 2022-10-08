container: "docker://condaforge/mambaforge"

rule deseq2:
    input: featureCount= "Step3G/counts_all.txt",
           metadata="meta/{sample}"
    output: "Step4G/normalized_table.csv"
    conda: "envs/deseq2.yaml"
    script: