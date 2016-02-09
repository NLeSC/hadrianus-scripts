#!/usr/bin/env bash

table=$1
verbose=false
if [ -n "$table" ]; then
  currentwd=$(pwd)
  cd /home/patrick/sw/projects/hadrianus/data/virtuoso/mysql
  t_conv=/home/patrick/sw/projects/hadrianus/data/virtuoso/mysql/schema_conv.pl
  data_conv=/home/patrick/sw/projects/hadrianus/data/virtuoso/mysql/data_conv.pl
  py_t_conv=/home/patrick/sw/projects/hadrianus/data/virtuoso/remove_last_comma.py

  if [ -n "$MYSQL_PWD" ]; then
    OPTION=""
  else
    OPTION="-p"
    echo "Type MySQL password twice (user hadrianus):"
  fi
  mysqldump --no-data -u hadrianus $OPTION knir1102_live "${table}" > "t_${table}.sql"
  mysqldump --no-create-info --extended-insert=FALSE -u hadrianus $OPTION knir1102_live "${table}" > "data_${table}.sql"

  "$t_conv" "t_${table}.sql" | "$py_t_conv" > "t_${table}_vir.sql"
  "$data_conv" "data_${table}.sql" > "data_${table}_vir.sql"

  schema_out=$(isql 1111 dba dba < "t_${table}_vir.sql" 2>&1)
  data_out=$(isql 1111 dba dba < "data_${table}_vir.sql" 2>&1)
  cd "$currentwd"

  if echo "$schema_out" | grep -qi error; then
    echo "error while ingesting schema for table $table!"
    if $verbose; then
      echo "$schema_out"
    fi
  elif echo "$data_out" | grep -qi error; then
    echo "error while ingesting data for table $table!"
    if $verbose; then
      echo "$data_out"
    fi
  else
    echo "table $table ingested successfully"
  fi
else
  echo "Specify the table name!"
fi
