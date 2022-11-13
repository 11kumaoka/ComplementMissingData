import pyper
import numpy as np
import pandas as pd
from statistics import variance 

from rdkit import Chem
from rdkit.Chem import AllChem
from IPython.display import HTML
# from malaria import utils, stats
# from standardiser import standardise
from scipy.spatial.distance import pdist, cdist
# df_tcams = pd.read_pickle('parsed/chembl_tcams.pkl')
# df_plas = pd.read_pickle('parsed/chembl_isidro.pkl')


import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

# Make R instance
r = pyper.R(use_numpy='True', use_pandas='True') 

# run the source code R
r("source(file='mixgbRun.R')")

## variables
## trel tsur relaps dead study stage histol instit age yr specwgt tumdiam 
original = r.get("rawdata")
originalWNA = r.get("rawdataWNA")
# print(type(originalWNA))
mixgbResult = r.get("imputed.data")
mixgbResult_m1 = mixgbResult[1]

## Write data on csv fiels to check contents   1111111111111111111111
# original.to_csv('nwtsco.csv')
# originalWNA.to_csv('nwtscoWNA.csv')
# mixgbResult_m1.to_csv('mixgbResult_m1.csv')


lenOfdata = len(original)
print('data length: {}'.format(lenOfdata))
l_l_diffArry = []
for column_name, item in original.iteritems():
    l_diffArry = []
    for index in range(lenOfdata):
        # print('origin:mixgb = {} : {}'.format(original[' age '][index],mixgbResult_m1[' age '][index]))
        # print(originalWNA[column_name][index])
        diff = original[column_name][index] - mixgbResult_m1[column_name][index]
        # if originalWNA[column_name][index] is not np.nan: continue ## ?????????
        if diff == 0: continue
        l_diffArry.append(diff)
    
    var = variance(l_diffArry)
    print('{} standard div : {}'.format(column_name, var))
    l_l_diffArry.append(l_diffArry)
    

pp = PdfPages('diffDist.pdf')
valNum = 0
for column_name, item in original.iteritems(): 
    fig = plt.figure()
    plt.hist(l_l_diffArry[valNum], bins=40, log=False, color="olivedrab")
    plt.title(column_name)
    
    pp.savefig(fig)
    valNum += 1
pp.close()







