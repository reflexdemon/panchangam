#!/bin/bash
if [[ $# -ne 3 ]]
then
    echo "Usage: ./gen_daily_png.sh <../../kamakoti-panchangam/drik/output/pdf/madrapurI-5123-śubhakr̥t-devanagari-daily-lagna-simple.pdf> <num_frontmatter_pages> 'April 14, 2022'"
    ## $2: This number if one less than the page number of the first daily sheet.
    exit 1
fi
nPages=367
start_date=`date --date "$3"`
name=`basename $1 | sed 's/\([0-9]\)-.*/\1/'`
echo Subject,Start Date,Start Time,End Date,End Time,Location > $name-PanchangaImage.csv
mkdir -p $name/daily
k=1
sp=$2
while [ $k -le $nPages ]
do
pdftoppm "$1" $name/daily/"`printf "%03d" $k`" -png -rx 300 -ry 300 -f $(( k+sp )) -singlefile
echo `date --date "$start_date +$((k-1)) days" "+%d %B %Y"`,`date --date "$start_date +$((k-2)) days" "+%d-%m-%y"`,20:00,`date --date "$start_date +$((k-2)) days" "+%d-%m-%y"`,20:30,https://github.com/karthikraman/panchangam/raw/master/png/$name/daily/`printf "%03d" $k`.png >> $name-PanchangaImage.csv
k=$(( k+1 ))
echo -ne .
if [[ $(( k%20 )) -eq 0 ]]
then
    echo "`printf "%4d" $k`" pages converted.
fi
done
echo Total of $k pages converted.
