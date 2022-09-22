rule summary_stat:
    input:  "{sample}sorted.bam"
    output: "{sample}samflagstat.txt"
    threads:    10
    shell:   'samtools flagstat {input} -@ {threads}  > {output} '


rule overall_alignment_rate:
        input:  expand("{dir}/{sample}samflagstat.txt", sample=SAMPLES, dir="samb")
        output: "overall_alignment_rate.txt"
        script: "scripts/overall_alignment_rate.py"

