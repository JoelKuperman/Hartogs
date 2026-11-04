#!/bin/bash

rootbase=$1
root=$rootbase.tex
arxiv_dir=__"$rootbase"_ArXiv_tmp
arxiv="$rootbase"_arxiv.tex
tgz="$rootbase"_arxiv.tar.gz
extra_files=""

pdflatex -draftmode \\nonstopmode \\input $root > /dev/null
bibtex $rootbase
makeindex $rootbase
pdflatex  -draftmode \\nonstopmode \\input $root > /dev/null
pdflatex \\nonstopmode \\input $root

mkdir $arxiv_dir

for x in *.tex
do
    scripts/stripcomments.pl $x > $arxiv_dir/$x
done

cp *sty *cls *bib *bst $extra_files $arxiv_dir

cd $arxiv_dir

rm -f notes.tex

cat $root > $arxiv
rm -f $root

tar --exclude=$root -zcvf $tgz *tex *bst *bib $extra_files
mv $tgz ..

cd ..

rm -rf $arxiv_dir
