RMDFILE=markdown
Rscript -e "require(knitr); knit('$RMDFILE.Rmd', '$RMDFILE.md');"
~/.cabal/bin/pandoc -s -S -i -t s5 markdown.md -o markdown.html --self-contained

cp markdown.html ~/Dropbox/haxogreen.lu

