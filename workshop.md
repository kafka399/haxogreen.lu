Twitter network data mining with R
===

[@dzidorius (Dzidas)](http://twitter.com/dzidorius)


fork code from  
[https://github.com/kafka399/haxogreen.lu](https://github.com/kafka399/haxogreen.lu) 

Prerequisite for R
===

    requirements=c('twitteR','tm','wordcloud','RColorBrewer','xtable')  
    if(length(requirements[which(!(requirements %in% 
		installed.packages()[,1]))])>0)  
        install.packages(requirements[which(!(requirements %in% 
		installed.packages()[,1]))])
Get the data
===

Who is tweeting about #Haxogreen


```r
require(twitteR)
# tweets=twitteR::searchTwitter('#haxogreen',n=2000)
load("tweets.Rdata")
names = sapply(tweets, function(x) x$screenName)
rez = (aggregate(names, list(factor(names)), length))
rez = rez[order(rez$x), ]
# rownames(rez)=NULL
colnames(rez) = c("name", "count")
# only for presentation
options(xtable.type = "html")
require(xtable)
xtable(t(tail(rez, 6)))
```

<!-- html table generated in R 2.15.1 by xtable 1.7-0 package -->
<!-- Wed Aug  1 11:51:32 2012 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> 23 </TH> <TH> 47 </TH> <TH> 3 </TH> <TH> 28 </TH> <TH> 7 </TH> <TH> 56 </TH>  </TR>
  <TR> <TD align="right"> name </TD> <TD> HoffmannMich </TD> <TD> psycon </TD> <TD> anachorete </TD> <TD> kwisArts </TD> <TD> bobreuter </TD> <TD> syn2cat </TD> </TR>
  <TR> <TD align="right"> count </TD> <TD>  8 </TD> <TD>  9 </TD> <TD> 10 </TD> <TD> 13 </TD> <TD> 15 </TD> <TD> 44 </TD> </TR>
   </TABLE>


Plot top10 tweeters
===

```r
barplot(tail(rez$count, 10), names.arg = as.character(tail(rez$name, 
    10)), cex.names = 0.7, las = 2)
```

![](figure/topspam.png) 


Who are these people
===

```r
# users=lookupUsers(as.character(tail(rez,3)$name))
load("users.Rdata")
users = lapply(users, function(x) {
    if (any(sapply(as.character(tail(rez, 3)$name), function(y) {
        x$screenName == y
    }))) 
        return(x)
})

users = users[!sapply(users, is.null)]

for (i in 1:length(users)) {
    cat(paste("**", users[[i]]$name, " @", users[[i]]$screenName, "**", "\n===\n", 
        sep = ""))
    cat(paste("![](http://api.twitter.com/1/users/profile_image?screen_name=", 
        users[[i]]$screenName, "&size=normal)", sep = ""))
    cat(paste("  \n**Created:** ", users[[i]]$created, "  \n**Spam rate:** ", 
        round(users[[i]]$followersCount/users[[i]]$friendsCount, digits = 2), 
        "  \n**Activity:** ", users[[i]]$statusesCount, "  \n**Location:** ", 
        users[[i]]$location, "  \n", users[[i]]$description, "  \n", "**Last status:** ", 
        (users[[i]]$lastStatus$text), "\n\n", sep = ""))
}
```

**Bob Reuter @bobreuter**
===
![](http://a0.twimg.com/profile_images/56437475/bob_reuter_normal.jpg)  
**Created:** 2008-04-01 12:43:44  
**Spam rate:** 1.03  
**Activity:** 567  
**Location:** Luxembourg  
I'm a Senior Lecturer in Educational Technology & Psychology @ University of Luxembourg.  
**Last status:** @rodlux there are toilets! Used them yesterday! and I can confirm the presence of showers!!! just saw somebody freshly showered! #haxogreen

**David Raison @kwisArts**
===
![](http://a0.twimg.com/profile_images/374576955/n1474584210_881_normal.jpg)  
**Created:** 2009-07-15 14:30:25  
**Spam rate:** 0.91  
**Activity:** 7138  
**Location:** Luxembourg  
cynic, founder at @syn2cat hackerspace / political science graduate / media science student  
**Last status:** RT @foobareV: Damit wir auf der #haxogreen die Orientierung nicht verlieren… http://t.co/UB20qhjH

**syn2cat a.s.b.l @syn2cat**
===
![](http://a0.twimg.com/profile_images/2253909465/weareinnovative-1_normal.png)  
**Created:** 2009-07-11 17:40:00  
**Spam rate:** 0.67  
**Activity:** 5994  
**Location:** Luxembourg  
syn2cat is a hackerspace located in Strassen, Luxembourg. Tweets from this account are brought to you by @SteveClement, @kwisArts and @tdegeling.  
**Last status:** RT @GuyFoetz: Good morning folks at #haxogreen ready to hack? =)

Exploring similarities - code
===


```r
## of line version users=lookupUsers(as.character(tail(rez,10)$name))
load("users.Rdata")

# friends=sapply(seq(1:10),function(x){(users[[x]]$getFriends())})
load("friends.Rdata")
matrix = matrix(nrow = 10, ncol = 10)
rez = apply(combn(1:10, 2), 2, function(x) {
    
    matrix[x[1], x[2]] = length(which(sapply(friends[[x[2]]], function(x) x$screenName) %in% 
        sapply(friends[[x[1]]], function(x) x$screenName)))/length(friends[[x[2]]])
})

rez3 = apply(combn(1:10, 2), 2, function(x) {
    
    matrix[x[1], x[2]] = length(which(sapply(friends[[x[1]]], function(x) x$screenName) %in% 
        sapply(friends[[x[2]]], function(x) x$screenName)))/length(friends[[x[1]]])
})

# rez2=combn(1:10,2)[,which(rez>.2)]

pairs = data.frame(pairs = apply(combn(1:10, 2)[, which(rez > 0.4)], 
    2, function(x) {
        paste(users[[x[1]]]$name, "~", users[[x[2]]]$name)
    }), rate = rez[which(rez > 0.4)])

pairs = rbind(pairs, data.frame(pairs = apply(combn(1:10, 2)[, which(rez3 > 
    0.4)], 2, function(x) {
    paste(users[[x[1]]]$name, "~", users[[x[2]]]$name)
}), rate = rez3[which(rez3 > 0.4)]))
```

Exploring similarities
===

```r
xtable(pairs[order(pairs$rate), ])
```

<!-- html table generated in R 2.15.1 by xtable 1.7-0 package -->
<!-- Wed Aug  1 11:52:00 2012 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> pairs </TH> <TH> rate </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> Michel Hoffmann ~ Pit Wenkin </TD> <TD align="right"> 0.44 </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> Pit Wenkin ~ David Raison </TD> <TD align="right"> 0.45 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> Michel Hoffmann ~ syn2cat a.s.b.l </TD> <TD align="right"> 0.49 </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> Pit Wenkin ~ syn2cat a.s.b.l </TD> <TD align="right"> 0.54 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> Michel Hoffmann ~ Thierry Degeling </TD> <TD align="right"> 0.58 </TD> </TR>
  <TR> <TD align="right"> 8 </TD> <TD> David Raison ~ syn2cat a.s.b.l </TD> <TD align="right"> 0.60 </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> Thierry Degeling ~ David Raison </TD> <TD align="right"> 0.67 </TD> </TR>
  <TR> <TD align="right"> 7 </TD> <TD> Thierry Degeling ~ syn2cat a.s.b.l </TD> <TD align="right"> 0.73 </TD> </TR>
   </TABLE>

Exploring dissimilarities - code
===


```r
pairs = data.frame(pairs = apply(combn(1:10, 2)[, which(rez < 0.007)], 
    2, function(x) {
        paste(users[[x[1]]]$name, "~", users[[x[2]]]$name)
    }), rate = rez[which(rez < 0.007)])

pairs = rbind(pairs, data.frame(pairs = apply(combn(1:10, 2)[, which(rez3 < 
    0.007)], 2, function(x) {
    paste(users[[x[1]]]$name, "~", users[[x[2]]]$name)
}), rate = rez3[which(rez3 < 0.007)]))
```

Exploring dissimilarities
===

```r
xtable(pairs[order(pairs$rate), ])
```

<!-- html table generated in R 2.15.1 by xtable 1.7-0 package -->
<!-- Wed Aug  1 11:52:00 2012 -->
<TABLE border=1>
<TR> <TH>  </TH> <TH> pairs </TH> <TH> rate </TH>  </TR>
  <TR> <TD align="right"> 11 </TD> <TD> anachorete ~ Dzidas </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> Tijmen Leroi ~ anachorete </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 7 </TD> <TD> Thierry Degeling ~ anachorete </TD> <TD align="right"> 0.00 </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> Tijmen Leroi ~ Bob Reuter </TD> <TD align="right"> 0.01 </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> psy ~ Bob Reuter </TD> <TD align="right"> 0.01 </TD> </TR>
  <TR> <TD align="right"> 1 </TD> <TD> Tijmen Leroi ~ psy </TD> <TD align="right"> 0.01 </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> Pit Wenkin ~ psy </TD> <TD align="right"> 0.01 </TD> </TR>
  <TR> <TD align="right"> 9 </TD> <TD> psy ~ Dzidas </TD> <TD align="right"> 0.01 </TD> </TR>
  <TR> <TD align="right"> 10 </TD> <TD> psy ~ Bob Reuter </TD> <TD align="right"> 0.01 </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> psy ~ anachorete </TD> <TD align="right"> 0.01 </TD> </TR>
  <TR> <TD align="right"> 8 </TD> <TD> Michel Hoffmann ~ Tijmen Leroi </TD> <TD align="right"> 0.01 </TD> </TR>
   </TABLE>


Word cloud - code
====


```r
# tweets=twitteR::searchTwitter('#haxogreen',n=2000)
load("tweets.Rdata")
tweets = sapply(tweets, function(x) x$text)
tweets = tweets[which(!unlist(sapply(seq(2:length(tweets)), function(x) {
    tweets[x] == tweets[x - 1]
}))) + 1]
require("tm")
corpus = Corpus(VectorSource(tweets), readerControl = list(language = "en"))
corpus = tm_map(corpus, tolower)
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, c(stopwords("english"), "rt"))

corpus.matrix = TermDocumentMatrix(corpus)
corpus = removeSparseTerms(corpus.matrix, 0.75)

rez = sort(rowSums(as.matrix(corpus.matrix)))
rez = data.frame(name = names(rez), count = as.numeric(rez))
rez = rez[-which(rez$name == "haxogreen"), ]
```

Word cloud 
===

```r
require(RColorBrewer)
require(wordcloud)
wordcloud(rez$name, rez$count, min.freq = 7, colors = brewer.pal(8, 
    "Dark2"))
```

![](figure/unnamed-chunk-8.png) 


Who Am I?
====

Dzidorius Martinaitis
 
> <font color = "grey">Java, C++ and R developer & data junkie</font>


+ blog:    [investuotojas.eu](http://www.investuotojas.eu)
+ twitter: [@dzidorius](http://www.twitter.com/dzidorius)
+ github:  [kafka399](http://https://github.com/kafka399)
+ linkedin: [dzidorius](http://lu.linkedin.com/in/dzidorius)
