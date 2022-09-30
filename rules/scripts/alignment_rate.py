import re
import pandas as pd
import os

my_dict = {"Sample_Name":[],"Overall alignment rate":[]}
for i in snakemake.input:
    sample= i.replace("step2/", "")
    lines = []
    with open(i) as f:
        lines = f.readlines()
    my_dict["Sample_Name"].append(sample)
    my_dict["Overall alignment rate"].append(re.search("\d+\s.\s\d+\smapped\s.(\d+.\d+.)", lines[4]).group(1))

data = pd.DataFrame.from_dict(my_dict)
data['Sample_Name'] = data['Sample_Name'].replace(to_replace='.samtools_flagstat.txt', value='',  regex=True)
data.to_csv(str(snakemake.output), index=None, sep='\t')