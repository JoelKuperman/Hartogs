#!/bin/bash
DIFF_DIR=diff_dir
if [ $2 ]; then 
    PREFIX=$2
else
    PREFIX=`basename $PWD`
fi
OLD_DIR=$DIFF_DIR/$PREFIX"_old"
NEW_DIR=$DIFF_DIR/$PREFIX"_new"
## SHA/tag of submitted version
OLDVER=$1
MAIN=$(basename -s .tex `grep -l documentclass *tex`)
DIFF_NAME=diff_"$OLDVER"_VS_today.tex

rm -rf $DIFF_DIR
mkdir $DIFF_DIR
mkdir $OLD_DIR $NEW_DIR
git archive $OLDVER | tar -x -C $OLD_DIR
cp * $NEW_DIR
cd $DIFF_DIR
cd $PREFIX"_old"/
pdflatex -draftmode \\nonstopmode\\input $MAIN.tex > /dev/null
bibtex $MAIN.aux
cd ..
latexdiff --flatten $PREFIX"_old"/$MAIN.tex $PREFIX"_new"/$MAIN.tex > $PREFIX"_new"/$DIFF_NAME
cd $PREFIX"_new"/
sed -i -- 's/Local Variables://g' $DIFF_NAME
pdflatex -draftmode \\nonstopmode\\input $DIFF_NAME > /dev/null
pdflatex \\nonstopmode\\input $DIFF_NAME
