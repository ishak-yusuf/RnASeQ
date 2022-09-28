import re
import pandas as pd
my_dict = {"Sample_Name":[],"Mapped Reads":[],"Mapped Unique Reads":[],"Exonic Rate":[],"Intronic Rate":[],"Intergenic Rate":[],"Ambiguous Alignment Rate":[],"rRNA Rate Alignment":[]}

for i in snakemake.input:
    lines = []
    with open(i) as f:
        lines = f.readlines()
    my_dict["Sample_Name"].append(re.search("^Sample.(\w+.\d+.\w+).\w+.\w+.\w", lines[0]).group(1))
    my_dict["Mapped Reads"].append(re.search("\w+\s\w+\t(\d+.\d+)", lines[51]).group(1))
    my_dict["Mapped Unique Reads"].append(re.search("\w+\s\w+\t(\d+.\d+)", lines[52]).group(1))
    my_dict["Exonic Rate"].append(re.search("\w+\s\w+\t(\d+|\d+.\d+)\n", lines[12]).group(1))
    my_dict["Intronic Rate"].append(re.search("\w+\s\w+\t(\d+|\d+.\d+)\n", lines[13]).group(1))
    my_dict["Intergenic Rate"].append(re.search("\w+\s\w+\t(\d+|\d+.\d+)\n", lines[15]).group(1))
    my_dict["Ambiguous Alignment Rate"].append(re.search("\w+\s\w+\t(\d+|\d+.\d+)\n", lines[16]).group(1))
    my_dict["rRNA Rate Alignment"].append(re.search("\w+\s\w+\t(\d+|\d+.\d+)\n", lines[23]).group(1))
data = pd.DataFrame.from_dict(my_dict)
data.to_csv(str(snakemake.output), index=None, sep='\t')