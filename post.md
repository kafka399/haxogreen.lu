If you need to build a presentation, obviously you have following options:


   - Powerpoint alike presentation
   - Online engines
   - [LaTex][1]


The first two are beloved by business people and the third one is widely used in academia. The objective of the first group is shiny presentation, contrary to the second where asceticism and demand for automation are top priorities. However, if you are data scientist or any other data specialist with a need to build an automated report, then you know, that LaTex is just wrong.  
LaTex allows you to build a shiny presentation or outstanding paper, however it can take light years to build something useful for beginners . If you never tried LaTex here is an example of the monster - you literally have to **code** a document or presentation:

    \documentclass{article}
    \title {Investment strategy}
    \author {Dzidorius Martinaitis}
    \begin{document}
    \maketitle
 
So, what do you do, if you need only 1% of all LaTex features and a report/document needs to be build automatically? Turns out, that HTML little brother [Markdown][2] is saving the world. Markdown(.md) source files are easy to read and easy to write and you can convert it into .html, .pdf, .docx, .tex or any other format. There are many ways to do conversion, however I use [Pandoc][pandoc] utility. By the way this post was written in markdown in [Vim][3] and you can check the [source file][4]. 


However, the nicest thing about Markdown is integration with R. You can build your report in one file, where R code would be embed in Markdown. [Knitr][knitr] package will help you to convert R code into Markdown simply by calling this piece of code:

    require(knitr);
    knit('workshop.Rmd', 'workshop.md');

Below you will find an excerpt of .Rmd file which is mix of R and Markdown:

    Get the data
    ===

    Who is tweeting about #Haxogreen

    ```{r results=asis,comment=NA, message=FALSE}
    require(twitteR)
    load('tweets.Rdata')
    names=sapply(tweets,function(x)x$screenName)
    rez=(aggregate(names,list(factor(names)),length))
    rez=rez[order(rez$x),]
    colnames(rez)=c('name','count')
    options(xtable.type = 'html')
    require(xtable)
    xtable(t(tail(rez,6)))
    ```

    Plot top10 tweeters
    ===
    ```{r topspam, figure=TRUE,fig.cap=''}
    barplot(tail(rez$count,10),names.arg=as.character(tail(rez$name,10)),cex.names=.7,las=2)
    ```


[Here is a workshop presentation][work_present] which contains the example above -  I built it for [Haxogreen][haxo] hackers camp and source code can be found on [gitHub][workshop]. 


[1]: http://www.latex-project.org/
[2]: http://en.wikipedia.org/wiki/Markdown 
[3]: http://www.vim.org/about.php
[4]: https://github.com/kafka399/haxogreen.lu
[pandoc]: http://johnmacfarlane.net/pandoc/
[knitr]: http://yihui.name/knitr/
[haxo]: www.haxogreen.lu
[workshop]: https://github.com/kafka399/haxogreen.lu/blob/master/workshop.Rmd
[work_present]: http://dl.dropbox.com/u/6360678/workshop.html
