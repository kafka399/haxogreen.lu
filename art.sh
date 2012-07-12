RMDFILE=article
Rscript -e "require(knitr); knit('$RMDFILE.Rmd', '$RMDFILE.md');"
pandoc -s -S -i $RMDFILE.md -o $RMDFILE.html

