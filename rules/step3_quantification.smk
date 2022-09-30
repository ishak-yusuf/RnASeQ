rule featureCounts:
    input:
        expand("step1/{sample}.sorted.bam", sample=getlist_id()),
    output:
        "step3/counts_all.txt",
    params:
        gff=config["gtf"],
        g="gene_name",
        t="exon",
    threads: config["th"]["max"]
    message:
        "--- Quantification with featureCounts "
    log:
        "step3/counts_all.txt.log",
<<<<<<< HEAD
    resources:
        mem_gb=126,
    container: "docker://condaforge/mambaforge"
    conda: "envs/quantification.yaml"
=======
    container:
        "docker://condaforge/mambaforge"
    conda:
        "envs/quantification.yaml"
>>>>>>> eef6195833c9382d82db0ee0cc91864fd060da0a
    shell:
        "featureCounts  -t {params.t}  -g  {params.g}  -a {params.gff} -o {output} -T {threads} {input} 2> {log}"