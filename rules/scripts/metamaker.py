import os
import pandas as pd
import sys
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-c', metavar="--csv", required=True, type= Path, help="Path to the metadata.csv file")



meta = parser.parse_args()

df= pd.read_csv(meta, sep=',')
for i in range(0,len(df['ID'])):
    #file name
    ID= df['ID'][i]
    #alocate cases and controls
    o= 1 + sum(s.count('case') for s in df)
    c= sum(s.count('control') for s in df)
    #make list of case and control and bulids dataframe of meta file
    case= list(df.iloc[i,1:o])
    control= list(df.iloc[i, o: o+c])
    my_dict = {"case":case,"control":control}
    data = pd.DataFrame(my_dict)
    #redesign the table and extract as file.csv 
    table= pd.melt(data, var_name ='condition')
    dtt= table.set_index('value') 
    dtt.to_csv(ID+'.csv', sep=',')

