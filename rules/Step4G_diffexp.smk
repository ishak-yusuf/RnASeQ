container: "docker://condaforge/mambaforge"


rule deseq2:
    input:
        featureCount="Step3G/counts_all.txt",
        metadata="input/{sample}",
    output:
        "Step4G/{sample}",
    conda:
        "envs/deseq2.yaml"
    script:
        "scripts/deseq2.R"
