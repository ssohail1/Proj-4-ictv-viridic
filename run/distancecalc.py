"""
Created on Fri Apr 29 10:31:39 2022

@author: jgrandinetti
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from pylab import savefig

current = os.getcwd()

fileA = pd.read_csv(current + '/results/totidentA.csv', sep = ',')
fileB = pd.read_csv(current + '/results/totidentB.csv', sep = ',')

fileA.columns = ['index','input_accessionID', 'database_accessionID', 'qstart', 'qend', 'nident','lenA','totidentAB']
fileB.columns = ['index','database_accessionID', 'input_accessionID', 'qstart', 'qend', 'nident','lenB','totidentBA']

fileAB = pd.merge(left = fileA, right = fileB[['database_accessionID','lenB','totidentBA']], how='right', on = 'database_accessionID')

def distance_calc(A, B, AB, BA):
    simAB = ((int(AB)+int(BA))*100)/(int(A)+int(B))
    distAB = 100 - simAB
    distAB = round(distAB,2)
    return distAB

fileAB['distanceAB'] = fileAB.apply(lambda x: distance_calc(x['lenA'], x['lenB'], x['totidentAB'], x['totidentBA']), axis=1)

fileABshort = fileAB[['input_accessionID','database_accessionID','distanceAB']].drop_duplicates(subset=None, keep='first', inplace=False)

result = fileABshort.pivot(index='input_accessionID', columns='database_accessionID', values='distanceAB')
heatmap = sns.heatmap(result, annot=True, fmt="g", cmap='viridis')

figure = heatmap.get_figure()
figure.savefig(current + '/results/heatmap.png', dpi = 600)
