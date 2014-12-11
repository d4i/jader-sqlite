JADER-SQLite
============

Japanese Adverse Drug Event Report database on SQLite3

Database Generation
-------------------

Creating Tables and Indexes

```sh
git clone https://github.com/dceoy/jader-sqlite.git
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
unzip /path/to/pmdacasereport20YYMM.zip && rm *.txt
YM=`ls demo*.csv | sed -e 's/^[a-z]\+\(20[0-9]\+\)\.csv$/\1/'`
nkf -w --overwrite *.csv
sed -ie '1d' *.csv
awk -F \" '{ gsub(/,/, "$", $0); gsub(/\$/, ",", $2); if (NF == 3) print $1"\""$2"\""$3; else print $1 }' drug$YM.csv > drug.utf8
rm drug$YM.csv
sed -ie 's/,/\$/g' *.csv
rename -v $YM.csv .utf8 *.csv
sed -ie 's/"/\\"/g' *.utf8
rm *e
cd ..
```

Import of Data

```sh
awk '$1 == "-" { print $2 }' table_list.yml | xargs -I {} sqlite3 -separator $ jader.sqlite3 '.import data/{}.utf8 {}'
```

Dump the Database

```sh
sqlite3 jader.sqlite3 '.dump' | gzip -c > dump_jader.sql.gz
```
