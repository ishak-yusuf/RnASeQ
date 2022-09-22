rule featureCounts:
    input:
        expand("{dir}/{sample}.sorted.bam", sample=getidlist(), dir="output"),
    output:
        "output/counts_all.txt",
    params:
        gff="/home/genwork2/Desktop/05.ref_area/ref_hisat2_annhg38p13/gencode_annotation.gff3",
        g="gene_name",
        t="exon",
    threads: 40
    message:
        "--- Quantification with featureCounts "
    log:
        "output/counts_all.txt.log",
    resources:
        mem_gb=126,
    conda: "envs/quantification.yaml"
    shell:
        "featureCounts  -t {params.t}  -g  {params.g}  -a {params.gff} -o {output} -T {threads} {input} 2> {log}"
