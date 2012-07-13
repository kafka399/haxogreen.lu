setwd('workspace/git')
tmp=read.table('stats2.csv',sep=',')
require('xts')
temp=xts(tmp[,-10],order.by=as.POSIXct(tmp[,10],origin='1970-01-01'))

#Number of connections made by the same source as the current record in the last 5 seconds
#Number of connections made to the same destination as the current record in the last 5 seconds
#Number of different services from the same source as the current record in the last 5 seconds
#Number of different services to the same destination as the current record in the last 5 seconds

