#----------------------------------------
# This script sets out to produce highly
# comparative time-series analysis of
# Google Trends data
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 31 August 2020
#----------------------------------------

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns; sns.set()
import catch22 as catch22
from catch22 import catch22_all
from sklearn import metrics

#%%
#---------------- LOAD AND PROCESS DATA ---------------

d = pd.read_csv("/Users/trenthenderson/Documents/R/google-trends/data/31_Aug_data.csv")

#%%
#---------------- HCTSA -------------------------------

searches = d.interest_over_time_keyword.unique()
search_data = []

for s in searches:
    tmp1 = d[d['interest_over_time_keyword'] == s]
    tmp1 = tmp1.dropna()
    tmp2 = tmp1[['interest_over_time_hits']]
    tmp2 = tmp2.to_numpy()
        
    results = pd.DataFrame.from_dict(catch22_all(tmp2))
    results['keyword'] = s
        
    search_data.append(results)

search_data = pd.concat(search_data)


#%%
#---------------- VISUALISATION -----------------------

# Standardise values

heat_data = search_data.assign(values = search_data.groupby('names').transform(lambda x: (x-x.mean())/x.std()))

heat_data = pd.pivot_table(heat_data, values = 'values', 
                              index = ['keyword'], 
                              columns = 'names')

fig, ax = plt.subplots(figsize = (10,10))
ax = sns.clustermap(heat_data, dendrogram_ratio = (.1, .1)) 
ax.cax.set_visible(False)

plt.savefig('/Users/trenthenderson/Documents/R/google-trends/output/clustermap.png', dpi = 500)
