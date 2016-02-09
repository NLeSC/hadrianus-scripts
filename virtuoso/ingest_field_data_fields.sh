#!/usr/bin/env bash

export MYSQL_PWD=hadrianus

usefultables=$(./field_data_types.sh)

echo "ingesting into Virtuoso..."

for table in $usefultables; do
  # || exit 1 -> exits on non-zero return (= error, hopefully)
  ./hadr_table_to_virtuoso.sh "$table" || exit 1
  # echo "
  # RETURN CODE: $?
  # "
done

echo "done ingesting into Virtuoso"

export MYSQL_PWD=""