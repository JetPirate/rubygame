#!/bin/sh
files_zip="rubygamelib.zip"
files_id="1R0zl6uLPlZ1iCDu8NmpRvSVn92N1ECvT"

curl -L -o ${files_zip} "https://drive.google.com/uc?export=download&id=${files_id}"
unzip -o $files_zip
rm -f $files_zip
