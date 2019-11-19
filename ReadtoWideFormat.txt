
PriceDataDf = spark.read.csv("wasb://bigdata2b@bigdata2bhdistorage.blob.core.windows.net/stockdata_small.csv", header=True, mode="DROPMALFORMED")

PriceDataDf.printSchema()
PriceDataDf.show()

import pandas as pd
import numpy as np

PriceDataPd = PriceDataDf.toPandas()
PriceDataPd.head(10)

PriceDataWide = PriceDataPd.pivot(index='Date', columns='Ticker', values='PxChange')
PriceDataWide.head(20)


