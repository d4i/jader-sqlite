#!/usr/bin/env bash

set -ue

JDR_SCHEMA_SQL="schema_jader.sql"
JDR_DB="db/jader.sqlite3"
JDR_DB_DUMP_GZ="db/dump_jader.sql.gz"
JDR_TABLES=$(awk '$1 == "-" { print $2 }' table_list.yml)

echo "> extracting files"
if [[ ${#} -eq 1 ]] && [[ ${1} =~ ^.*\.zip$ ]]; then
  [[ -d raw/ ]] || mkdir raw/
  unzip ${1} -d raw/
else
  echo "Invarid arguement." && exit 1
fi

echo "> checking files."
ls raw/*.csv
if [[ ! ${?} -eq 0 ]]; then
  echo "CSV files not found." && exit 1
fi

echo "> checking required system commands."
which csvformat
which nkf
which sqlite3

echo "> creating the database."
if [[ ! -f ${JDR_DB} ]]; then
  [[ -d db/ ]] || mkdir db/
  cat ${JDR_SCHEMA_SQL} | sqlite3 ${JDR_DB}
  sqlite3 ${JDR_DB} '.tables'
fi

echo "> migrating the JADER data..."
[[ -d seed/ ]] || mkdir seed/
for t in ${JDR_TABLES[@]}; do
  echo ${t}
  nkf -w raw/${t}20????.csv | tail -n +2 | csvformat -d , -D $ -b > seed/${t}.utf8
  sqlite3 -separator $ ${JDR_DB} ".import seed/${t}.utf8 ${t}"
done

echo "> dumping the database..."
sqlite3 ${JDR_DB} '.dump' | gzip - > ${JDR_DB_DUMP_GZ}

echo "complete."
