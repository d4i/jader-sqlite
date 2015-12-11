#!/usr/bin/env bash

set -ue

JDR_SCHEMA_SQL="schema_jader.sql"
JDR_DB="db/jader.sqlite3"
JDR_DB_DUMP_GZ="db/dump_jader.sql.gz"
JDR_TABLES=$(awk '$1 == "-" { print $2 }' table_list.yml)

echo "> checking required system commands."
which csvformat
which nkf
which sqlite3

echo "> creating the database."
if [ ! -f ${JDR_DB} ]; then
  [[ -d db/ ]] || mkdir db/
  cat ${JDR_SCHEMA_SQL} | sqlite3 ${JDR_DB}
  sqlite3 ${JDR_DB} '.tables'
fi

echo "> migrating the JADER data..."
if ls raw/*.csv > /dev/null; then
  [[ -d seed/ ]] || mkdir seed/
  for t in ${JDR_TABLES[@]}; do
    echo ${t}
    nkf -w raw/${t}20????.csv | tail -n +2 | csvformat -d , -D $ -b > seed/${t}.utf8
    sqlite3 -separator $ ${JDR_DB} ".import seed/${t}.utf8 ${t}"
  done
else
  echo "Put JADER CSV files at ./raw directory!"
  exit
fi

echo "> dumping the database..."
sqlite3 ${JDR_DB} '.dump' | gzip - > ${JDR_DB_DUMP_GZ}

echo "complete."
