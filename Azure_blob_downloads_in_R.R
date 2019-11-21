#install.packages("AzureStor")
library(AzureStor)


# get the storage account object
#stor <- AzureRMR::az_rm$
#  new()$
#  get_subscription("884859e2-5bb7-43d3-b147-5d0deda10bc0")$
#  get_resource_group("Sparkling")$
#  get_storage_account("bigdata1hdistorage")

#stor$get_blob_endpoint()
# Azure blob storage endpoint
# URL: https://mynewstorage.blob.core.windows.net/
# Access key: <hidden>
# Account shared access signature: <none supplied>
# Storage API version: 2018-03-28


## Download files directly from Azure Blob Storages based on supplied URL into your working directory
# nodes.csv
download_from_url(
  "https://bigdataissstorageasia.blob.core.windows.net/graphnodes/nodes.csv",
  "nodes.csv",
  key="zm5Yr4YadxB/ZEvhyOISOw9hh5MCeVUA07A76EsBVBpX/jP6aDtHRBUCGIE5cp1mMMyzQQ2A7DCOz632hLa59A==", 
  overwrite=T)

# edges.csv
download_from_url(
  "https://bigdataissstorageasia.blob.core.windows.net/graphedges/edges.csv",
  "edges.csv",
  key="zm5Yr4YadxB/ZEvhyOISOw9hh5MCeVUA07A76EsBVBpX/jP6aDtHRBUCGIE5cp1mMMyzQQ2A7DCOz632hLa59A==", 
  overwrite=T)
