RMDFILE=presentation
Rscript -e "require(knitr); knit('$RMDFILE.Rmd', '$RMDFILE.md');"
pandoc -s -S -i -t dzslides $RMDFILE.md -o $RMDFILE.html --self-contained
