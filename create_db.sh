#!/usr/bin/env bash
#
# Usage:  ./create_db.sh [--zip file]
#         ./create_db.sh [--csv directory]
#         ./create_db.sh [ -h | --help | -v | --version ]
#
# Description:
#   Create an SQLite3 database with JADER
#
# Options:
#   -h, --help          Print usage
#   -v, --version       Print version information and quit
#   --zip               Migrate data from a ZIP file
#   --csv               Migrate data from CSV files in a directory

set -e

if [[ "${1}" = '--debug' ]]; then
  set -x
  shift 1
fi

SCRIPT_NAME='create_db.sh'
SCRIPT_VERSION='1.1.0'
JDR_SCHEMA_SQL='./schema_jader.sql'
DB_DIR='./db'
DB_SEED_DIR="${DB_DIR}/seed"
JDR_DB="${DB_DIR}/jader.sqlite3"
JDR_DB_DUMP_GZ="${DB_DIR}/dump_jader.sql.gz"

[[ -d "${DB_SEED_DIR}" ]] || mkdir -p ${DB_SEED_DIR}

function print_version {
  echo "${SCRIPT_NAME}: ${SCRIPT_VERSION}"
}

function print_usage {
  ${SED} -ne '
    1,2d
    /^#/!q
    s/^#$/# /
    s/^# //p
  ' ${SCRIPT_NAME}
}

function abort {
  {
    if [[ ${#} -eq 0 ]]; then
      cat -
    else
      echo "${SCRIPT_NAME}: ${*}"
    fi
  } >&2
  exit 1
}

case "${OSTYPE}" in
  'darwin'* )
    SED='gsed'
    ;;
  'linux'* )
    SED='sed'
    ;;
  * )
    abort 'not supported OS type'
    ;;
esac

case "${1}" in
  '' )
    {
      print_version && echo && print_usage
    } | abort
    ;;
  '-v' | '--version' )
    print_version
    exit 0
    ;;
  '-h' | '--help' )
    print_usage
    exit 0
    ;;
  '--zip' )
    [[ -n "${2}" ]] || abort 'missing a target file'
    CSV_DIR='./csv'
    echo '> extracting files.'
    unzip ${2} -d ${CSV_DIR}
    echo
    ;;
  '--csv' )
    [[ -n "${2}" ]] || abort 'missing a target directory'
    CSV_DIR="$(dirname ${2})/$(basename ${2})"
    ;;
  * )
    abort "invalid argument \`${1}\`"
    ;;
esac

echo '> checking the commands.'
echo '[CSVKit]' && which csvformat
echo '[NKF]' && which nkf
echo '[SQLite3]' && which sqlite3
echo

echo '> creating the database.'
echo "${JDR_SCHEMA_SQL} => ${JDR_DB}"
if [[ -f "${JDR_DB}" ]]; then
  abort "\`${JDR_DB}\` already exists."
else
  sqlite3 ${JDR_DB} ".read ${JDR_SCHEMA_SQL}"
fi

echo '> migrating the JADER data...'
for t in $(${SED} -ne 's/^CREATE TABLE \([a-z_]\+\) (/\1/gp' ${JDR_SCHEMA_SQL}); do
  csv="$(find ${CSV_DIR} -name "${t}20????.csv")"
  seed="${DB_SEED_DIR}/${t}.utf8"
  [[ -n "${csv}" ]] || continue
  echo "${csv} => ${seed} => ${JDR_DB} (table: \`${t}\`)"
  nkf -w "${csv}" | tail -n +2 | csvformat -d , -D $ -b > ${seed}
  sqlite3 -separator '$' ${JDR_DB} ".import ${seed} ${t}"
done
echo

echo '> dumping the database...'
echo "${JDR_DB} => ${JDR_DB_DUMP_GZ}"
sqlite3 ${JDR_DB} '.dump' | gzip - > ${JDR_DB_DUMP_GZ}
echo

echo 'done.'
