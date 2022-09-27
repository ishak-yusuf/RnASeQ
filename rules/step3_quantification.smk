rule featureCounts:
    input:
        expand("step2/{sample}.sorted.bam", sample=getlist_id()),
    output:
        "output/counts_all.txt",
    params:
        gff= config ['gtf'],
        g="gene_name",
        t="exon",
    threads: 40
    message:
        "--- Quantification with featureCounts "
    log:
        "/counts_all.txt.log",
    resources:
        mem_gb=126,
    container: "docker://condaforge/mambaforge"
    conda: "envs/quantification.yaml"
    shell:
        "featureCounts  -t {params.t}  -g  {params.g}  -a {params.gff} -o {output} -T {threads} {input} 2> {log}"
