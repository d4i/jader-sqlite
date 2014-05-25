JADER-SQLite
============

Japanese Adverse Drug Event Report database on SQLite3

Database Generation
-------------------

Creating Tables and Indexes

```sh
git clone https://github.com/d4i/jader-sqlite.git
cd jader-sqlite
sqlite3 jader.sqlite3 '.read schema_jader.sql'
```

Import of JADER
---------------

Preparation of Data  
Use GNU sed and GNU awk.

```sh
mkdir data/
cd data/
unzip /path/to/pmdacasereportXXYY.zip
nkf -w --overwrite *.csv
sed -ie 's/,/\$/g' *.csv
awk -F \" '{ sub(/\$/, ",", $2); if (NF == 3) print $1"\""$2"\""$3; else print $1 }' drug20XXYY.csv > drug.utf8
rm drug20XXYY.csv
rename -s 20XXYY.csv .utf8 *.csv
rm *.csve *.txt
cd ..
```

Import of Data

```sh
ls data/ | sed -e 's/\.utf8//g' | xargs -I {} sqlite3 -separator $ jader.sqlite3 '.import data/{}.utf8 {}'
```
