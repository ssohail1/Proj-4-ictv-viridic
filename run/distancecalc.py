"""
Created on Fri Apr 29 10:31:39 2022

@author: jgrandinetti
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from pylab import savefig
import os

current = os.getcwd()

fileA = pd.read_csv(current + '/totidentA.csv', sep = ',')
fileB = pd.read_csv(current + '/totidentB.csv', sep = ',')

fileA.columns = ['index','input_accessionID', 'database_accessionID', 'qstart', 'qend', 'nident','lenA','totidentAB']
fileB.columns = ['index','database_accessionID', 'input_accessionID', 'qstart', 'qend', 'nident','lenB','totidentBA']

fileAB = pd.merge(left = fileA, right = fileB[['database_accessionID','lenB','totidentBA']], how='right', on = 'database_accessionID')

fileAB = fileAB.dropna()

def distance_calc(A, B, AB, BA):
    simAB = ((int(AB)+int(BA))*100)/(int(A)+int(B))
    distAB = 100 - simAB
    distAB = round(distAB,2)
    return distAB

fileAB['distanceAB'] = fileAB.apply(lambda x: distance_calc(x['lenA'], x['lenB'], x['totidentAB'], x['totidentBA']), axis=1)

fileABshort = fileAB[['input_accessionID','database_accessionID','distanceAB']].drop_duplicates(subset=None, keep='first', inplace=False).head(100)

with open(current + '/results/results.csv','w') as f: #open csv file to write
    fileABshort.to_csv(f) #write dataframe from list to csv

result = fileABshort.pivot_table(index='input_accessionID', columns='database_accessionID', values='distanceAB')

fig, ax = plt.subplots(figsize=(len(result.columns),len(result)))

heatmap = sns.heatmap(result, annot=True, fmt="g", cmap='viridis', linewidths=5)

figure = heatmap.get_figure()
figure.savefig(current + '/results/heatmap.png', dpi = 300, bbox_inches='tight')
