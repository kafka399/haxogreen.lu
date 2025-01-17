In preparation for [\"Haxogreen\" hackers summer camp](http://www.haxogreen.lu) which takes place in Luxembourg, I was exploring network security world. My motivation was to find out how data mining is applicable to network security and intrusion detection. 


[Flame virus](http://en.wikipedia.org/wiki/Flame_(malware)), [Stuxnet](http://en.wikipedia.org/wiki/Stuxnet), [Duqu](http://en.wikipedia.org/wiki/Duqu) proved that static, signature based security systems are not able to detect very advanced, government sponsored threats. Nevertheless, signature based defense systems are mainstream today - think of antivirus, intrusion detection systems. What do you do when unknown is unknown? Data mining comes to mind as the answer.   


There are following areas where data mining is or can be employed: misuse/signature detection, anomaly detection, scan detection, etc.


Misuse/signature detection systems are based on supervised learning. During learning phase, labeled examples of network packets or systems calls are provided, from which algorithm can learn about the threats. This is very efficient and fast way to find know threats. Nevertheless there are some important drawbacks, namely false positives, novel attacks and complication of obtaining initial data for training of the system.    
The false positives happens, when normal network flow or system calls are marked as a threat. For example, an user can fail to provide the correct password for three times in a row or start using the service which is deviation from the standard profile. Novel attack can be define as an attack not seen by the system, meaning that signature or the pattern of such attack is not learned and the system will be penetrated without the knowledge of the administrator. The latter obstacle (training dataset) can be overcome by collecting the data over time or relaying on public data, such as [DARPA Intrusion Detection Data Set](http://www.ll.mit.edu/mission/communications/ist/corpora/ideval/data/index.html).   
Although misuse detection can be built on your own data mining techniques, I would suggest well known product like [Snort](http://www.snort.org/) which relays on crowdsourcing. 
 

Anomaly/outlier detection systems looks for deviation from normal or established patterns within given data. In case of network security any threat will be marked as an anomaly. Below you can find two features graph, where number of logins are plotted on x axis and number of queries are plotter on y axis. The color indicates the group to which points are assigned - blue ones are normal, red ones - anomalies.     


[![alt text](http://i176.photobucket.com/albums/w180/investuotojas/start_dec_anomalies.png)](http://s176.photobucket.com/albums/w180/investuotojas/?action=view&current=start_dec_anomalies.png) 


Anomaly detection systems constantly evolves - what was a norm year ago can be an anomaly today. The algorithm compares network flow with historical flow over given period and looks for outliers with are far away. Such dynamic approach allows to detect novel attacks, nevertheless it generates false positive alerts (marks normal flow as suspicious). Moreover, hackers can mimic normal profile, if they know that such system is deployed.    

The first task when implementing anomaly detection (AD) is collection of the data. If AD is going to be network based, there are two possibilities to collect aggregated data from network. Some Cisco products provide aggregated data as [Netflow](http://www.cisco.com/en/US/products/ps6601/products_ios_protocol_group_home.html) protocol. However, you can use [Wireshark or tshark](http://www.wireshark.org) to collect network flow data from the computer. For example:   

 
> tshark -T fields -E separator , -E quote d -e ip.src -e ip.dst -e tcp.srcport -e tcp.dstport -e udp.srcport -e upd.dstport -e tcp.len -e ip.len -e eth.type -e frame.time_epoch -e frame.len


Once you have enough data for mining process, you need to preprocess aquired data. In the context of intrusion, anomalous actions happen in bursts rather than single event. [Varun Chandola et al.][1] proposed to derive following features:

* Time window based:
:   Number of flows to unique destination IP addresses inside the network in the last T seconds from the same source
:   Number of flows from unique source IP addresses inside the network in the last T seconds to the same destination
:   Number of flows from the source IP to the same destination port in the last T seconds host based - system calls network based - packet information
:   Number of flows to the destination IP address using same source port in the last T seconds   

* Connection based:
:   Number of flows to unique destination IP addresses inside the network in the last N flows from the same source
:   Number of flows from unique source IP addresses inside the network in the last N flows to the same destination
:   Number of flows from the source IP to the same destination port in the last N flows
:   Number of flows to the destination IP address using same source port in the last N flows



Below you can find an example of feature creation in R. The dataset was created by calling tshark script, which is specified above.  


> \#load data  
> tmp=read.csv('stats2.csv',colClasses=c(rep('character',11)),header=F)  
> \#get rid of everything below min. in timestamp  
> tmp[,10]=as.integer(as.POSIXct(format(as.POSIXct(as.integer(tmp[,10]),origin='1970-01-01'),'%Y-%m-%d %H:%M:00')))   
> \#fix some rows  
> tmp=tmp[-which(sapply(tmp[,1],function(x) nchar(x)>15)),]
> tmp=tmp[which(!is.na(tmp[,4])),]
> 
> \#aggregate date by 5 mins. it assumes, that flow is continuous  
> factor=as.factor(tmp[1:5000,10])
> 
> feature=do.call(rbind,
>              sapply(seq(from=1,to=length(factor),by=4),function(x){
>   return(list(ddply(
>     subset(tmp,factor==levels(factor)[x:(x+4)]),.(V1,V4),summarize,times=length(V11),.parallel=FALSE
>     )))
> }))

After preprocessing the data we can apply local outlier detection, KNN, random forest and others algorithms. I will  provide R code and practical implementation of some algorithms in the following post.



While preparing this post, I was looking for the books, I found only few books covering data mining and network security. To my suprise [Data Mining and Machine Learning in Cybersecurity][2] book includes both topics and well written. However, if you are security specialist looking for data mining books, you can read my [summary][3] of [\"Data Mining: Practical Machine Learning Tools and Techniques\"][4]       
 
[1]: http://minds.cs.umn.edu/publications/chapter.pdf "Data Mining for Cyber Security"
[2]: http://www.amazon.com/gp/product/1439839425/ref=as_li_qf_sp_asin_tl?ie=UTF8&tag=quantitativ0e-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=1439839425
[3]: http://www.investuotojas.eu/2012/07/02/my-first-competition-at-kaggle/
[4]: http://www.amazon.com/gp/product/0123748569/ref=as_li_tf_tl?ie=UTF8&tag=quantitativ0e-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=0123748569 "Data Mining: Practical Machine Learning Tools and Techniques".
