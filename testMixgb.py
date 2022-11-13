import pyper
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

# read the CSV data in Python
wine = pd.read_csv("wine.csv")


# Make R instance
# r = pyper.R(use_pandas='True')
r = pyper.R(use_numpy='True', use_pandas='True') 


# Send the object of Python to R
r.assign("data", wine)


# run the source code R
# r("source(file='scatter.R')")
r("source(file='runBaseMixgb.R')")

mixgbResult = r.get("imputed.data") ## now it return as list. I want to get as pandas...
# mixgbResult = r.get("mixgb_1")
# print(mixgbResult)
print(type(mixgbResult))
print(len(mixgbResult))

print(type(mixgbResult[1]))
print(len(mixgbResult[1]))

print('Checkuma111')
# mixgbResult_Chi = pd.Series(mixgbResult[1])
mixgbResult_Chi = mixgbResult[1]
print(mixgbResult_Chi.shape)
print(mixgbResult_Chi.index)
print(mixgbResult_Chi.columns)
print(mixgbResult_Chi.dtypes)
print('Checkuma111')

print(mixgbResult_Chi[' BMPHEAD '])
mixgbResult_Chi_BMPHEAD = pd.to_numeric(mixgbResult_Chi[' BMPHEAD '])
print(type(mixgbResult_Chi_BMPHEAD))
print('Checkuma222')


print('Checkuma333')
d_nhanes3 = r.get("originalTuto.data")
print(type(d_nhanes3))
print(d_nhanes3)
print('Checkuma333')
# d_nhanes3.to_csv('nhanes3_newborn.csv')
mixgbResult_Chi.to_csv('mixgbResult_Chi.csv')

# mixgbResult = r.get("mixgb_1")
pp = PdfPages('pdf_test.pdf')
for i in range(5):
    fig = plt.figure()
    mixgbResult_Chi = mixgbResult[i]
    mixgbResult_Chi_BMPHEAD = pd.to_numeric(mixgbResult_Chi[' BMPHEAD '])
    tempValue_l = mixgbResult_Chi_BMPHEAD.plot(kind="hist")
    # plt.plot(tempValue_l,'o', color='C'+str(i))
    pp.savefig(fig)
pp.close()
print()






