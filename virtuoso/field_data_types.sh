#!/usr/bin/env bash

export MYSQL_PWD=hadrianus

columnstables=$(mysql -u hadrianus knir1102_live -N -s -e "SELECT TABLE_NAME,COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME LIKE 'field_%' AND TABLE_NAME LIKE 'field_data_field%';")

tables=$(echo "$columnstables" | cut -f1 | uniq)

# echo "$columnstables"

typespertable=$(
for table in $tables; do
  # echo "$table:"
  fieldname=$(echo "$table" | sed -r 's/field_data_field_(.*)/\1/')
  # echo "$fieldname"
  datacolumns=$(echo "$columnstables" | grep "field_data_field_${fieldname}"$'\t' | cut -f2 | sed -r 's/field_'"$fieldname"'_(.*)/\1/' | paste -sd ',')
  echo -e "$fieldname\t$datacolumns"
done
)

# echo "$typespertable"

# ./field_data_types.sh | cut -f2 | sort | uniq
# Useful:
# lid
# target_id
# tid
# Not sure:
# fid,alt,title,width,height
# Literals:
# value
# value,format
# value,revision_id
# value,value2
# Not useful:
# url,title,attributes

# echo "
# Useful:
# "
# echo "$typespertable" | grep tid
# echo
# echo "$typespertable" | grep lid
# echo
# echo "$typespertable" | grep target_id
# echo "
# Also possibly useful:
# "
# echo "$typespertable" | grep fid,alt,title,width,height

# first set (these were already put in Virtuoso database at this time, 2 Feb)
useful1=$(echo "$typespertable" | grep 'lid\|target_id')

# echo "First set of tables to be joined with node Triples:"
# echo "$useful1" | cut -f1

fieldnames=$(echo "$useful1" | cut -f1)
usefultables=""
for field in $fieldnames; do
  usefultables+="field_data_field_${field}
"
done

echo "$usefultables"

export MYSQL_PWD=""