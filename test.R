setwd('workspace/git')
setwd('~/git/haxogreen.lu/')
#tmp=read.table('stats2.csv',sep=',',quote='"')

require('xts')
#temp=xts(tmp[,-10],order.by=as.POSIXct(tmp[,10],origin='1970-01-01'))

#temp=temp[which(sapply(temp[,1],nchar)<=15),]

#Number of connections made by the same source as the current record in the last 5 seconds
#Number of connections made to the same destination as the current record in the last 5 seconds
#Number of different services from the same source as the current record in the last 5 seconds
#Number of different services to the same destination as the current record in the last 5 seconds


###load data###
tmp=read.csv('stats2.csv',colClasses=c(rep('character',11)),header=F)

###get rid of everything below min. in timestamp
tmp[,10]=as.integer(as.POSIXct(format(as.POSIXct(as.integer(tmp[,10]),origin='1970-01-01'),'%Y-%m-%d %H:%M:00')))

###fix some rows###
tmp=tmp[-which(sapply(tmp[,1],function(x) nchar(x)>15)),]
tmp=tmp[which(!is.na(tmp[,4])),]

###aggregate date by 5 mins.### it assumes, that flow is continous
factor=as.factor(tmp[1:5000,10])

feature=do.call(rbind,
             sapply(seq(from=1,to=length(factor),by=4),function(x){
  return(list(ddply(
    subset(tmp,factor==levels(factor)[x:(x+4)]),.(V1,V4),summarize,times=length(V11),.parallel=FALSE
    )))
}))


nasa=rollapply(levels(factor),5,function(x){
  ddply(subset(tmp,factor==x),.(V1,V4),summarize,times=length(V11))},align='right')


  #ddply(
    subset(tmp,factor==levels(factor)[x:(x+4)])
    #,.(V1,V4),summarize,times=length(V11))
  })
  levels(factor)[x:(x+4)]
       )

aggregate(tmp[1:50000,],list(factor),function(x) 
  
  ddply(x,.(V1,V4),summarize,sux=length(V11)))
ddply(tmp[1:50000,],.(V1,V4),summarize,sux=length(V11))

apply