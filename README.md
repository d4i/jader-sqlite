JADER-SQLite
============

Japanese Adverse Drug Event Report database on SQLite3

Database Generation
-------------------

Creating Tables and Indexes

```sh
$ git clone https://github.com/dceoy/jader-sqlite.git
$ cd jader-sqlite
$ sqlite3 jader.sqlite3 '.read schema_jader.sql'
```

Import of JADER
---------------

Preparation of Data  
Use [psv](https://github.com/dceoy/psv) command.

```sh
$ mkdir data/
$ cd data/
$ unzip /path/to/pmdacasereport20YYMM.zip && rm *.txt
$ sed -ie '1d' *.csv
$ rm *e
$ nkf -w --overwrite *.csv
$ YM=`ls demo*.csv | sed -e 's/^[a-z]\+\(20[0-9]\+\)\.csv$/\1/'`
$ for i in `awk '$1 == "-" { print $2 }' ../table_list.yml`; do psv -s $ $i$YM.csv > $i.utf8; done
$ cd ..
```

Import of Data

```sh
$ awk '$1 == "-" { print $2 }' table_list.yml | xargs -I {} sqlite3 -separator $ jader.sqlite3 '.import data/{}.utf8 {}'
```

Dump the Database

```sh
$ sqlite3 jader.sqlite3 '.dump' | gzip -c > dump_jader.sql.gz
```
