import os
import re
import pandas as pd


##Read in parameters from snakemake

my_dict = {"Sample_Name":[],"Overall alignment rate":[]}
for i in snakemake.input:
    print(i)
    lines = []
    with open(i) as f:
        lines = f.readlines()
    my_dict["Sample_Name"].append(os.path.basename(i))
    my_dict["Overall alignment rate"].append(re.search("\d+\s.\s\d+\smapped\s.(\d+.\d+.)", lines[4]).group(1))

data = pd.DataFrame.from_dict(my_dict)
data['Sample_Name'] = data['Sample_Name'].replace(to_replace='.samb.txt', value='',  regex=True)
data.to_csv(str(snakemake.output), index=None, sep='\t')