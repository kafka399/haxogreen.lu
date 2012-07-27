RMDFILE=workshop
Rscript -e "require(knitr); knit('$RMDFILE.Rmd', '$RMDFILE.md');"
pandoc -s -S -i -t slidy $RMDFILE.md -o $RMDFILE.html --self-contained --mathjax
