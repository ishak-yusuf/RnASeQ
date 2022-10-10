rule featureCounts:
    input:
        expand("Step1G/{sample}.sorted.bam", sample=getlist_id()),
    output:
        "Step3G/counts_all.txt",
    params:
        gtf=config["gtf"],
        g="gene_name",
        t="exon",
    threads: config["th"]["max"]
    message:
        "--- Quantification with featureCounts "
    log:
        "Step3G/counts_all.txt.log",
    resources:
        mem_gb=126,
    container:
        "docker://condaforge/mambaforge"
    conda:
        "envs/quantification.yaml"
    shell:
        """
        featureCounts  -t {params.t}  -g  {params.g}  -a {params.gtf} -o {output} -T {threads} {input} 2> {log}
        sed -i '1d' {output}
        sed -i 's/.sorted.bam//g' {output}
        sed -i 's/Step1G\///g' {output}
        cut -f1,7-  {output} > file.txt
        rm {output}
        mv file.txt {output}
        """
