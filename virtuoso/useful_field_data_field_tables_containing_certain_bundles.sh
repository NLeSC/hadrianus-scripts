#!/usr/bin/env bash

export MYSQL_PWD=hadrianus

tables=$(./field_data_types.sh)

columnstables=$(mysql -u hadrianus knir1102_live -N -s -e "SELECT TABLE_NAME,COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME LIKE 'field_%' AND TABLE_NAME LIKE 'field_data_field%';")

bundles=""

for table in $tables; do
  fieldname="${table:17:${#table}}"
  # camelcase=$(echo "$fieldname" | sed -r 's/_([a-z])/\U\1/g' | sed -r 's/_(.)/\1/g')
  # echo "$fieldname ($camelcase):"
  bundles+=$(mysql -u hadrianus knir1102_live -N -s -e "SELECT DISTINCT bundle FROM field_data_field_${fieldname};")
  bundles+="
"
done

unique_bundles=$(echo "${bundles}" | sort | uniq | awk NF | grep -v page)

# echo "$unique_bundles"
# address
# field_collection_inhabitants
# field_collection_inhabitants_2
# group
# locatie
# object
# page
# person


for bundle in $unique_bundles; do
  bundle_tables=""
  for table in $tables; do
    fieldname="${table:17:${#table}}"
    bundle_count=$(mysql -u hadrianus knir1102_live -N -s -e "
                   SELECT count(*) FROM field_data_field_${fieldname} WHERE bundle = '${bundle}';")
    if [[ $bundle_count -gt 0 ]]; then
      # then also add the field type
      datacolumns=$(echo "$columnstables" | grep "field_data_field_${fieldname}"$'\t' | cut -f2 | sed -r 's/field_'"$fieldname"'_(.*)/\1/' | paste -sd ',')
      bundle_tables+="$table   $datacolumns
"
    fi
  done
  echo "$bundle:"
  echo "$bundle_tables"
done

# address:
# field_data_field_address_description
# field_data_field_collection_inhabitants
# field_data_field_collection_inhabitants_2
# field_data_field_coords
# field_data_field_house_number
# field_data_field_house_owner
# field_data_field_parish
# field_data_field_street

# field_collection_inhabitants:
# field_data_field_inhabitant
# field_data_field_inhabitant_period
# field_data_field_inhabitant_reliability
# field_data_field_inhabitant_remarks
# field_data_field_inhabitant_source

# field_collection_inhabitants_2:
# field_data_field_inhabitant_2
# field_data_field_inhabitant_period
# field_data_field_inhabitant_reliability
# field_data_field_inhabitant_remarks
# field_data_field_inhabitant_source

# group:
# field_data_field_bibliography
# field_data_field_image
# field_data_field_open_popup
# field_data_field_years_in_rome
# field_data_field_years_rome

# locatie:
# field_data_field_body_actual
# field_data_field_body_historic
# field_data_field_body_represented
# field_data_field_coords
# field_data_field_icon
# field_data_field_type

# object:
# field_data_field_actual_location
# field_data_field_collection
# field_data_field_dimensions
# field_data_field_image
# field_data_field_location
# field_data_field_location_of_work_shown
# field_data_field_material_tagging
# field_data_field_open_popup
# field_data_field_period_end
# field_data_field_period_start
# field_data_field_person
# field_data_field_subtitle
# field_data_field_websource
# field_data_field_work_type_tagging

# person:
# field_data_field_address
# field_data_field_alphabetical_name
# field_data_field_alternative_name
# field_data_field_bibliography
# field_data_field_date_of_birth
# field_data_field_date_of_death
# field_data_field_dutch_residence_after
# field_data_field_dutch_residence_before
# field_data_field_employment
# field_data_field_group
# field_data_field_image
# field_data_field_life_and_death
# field_data_field_open_popup
# field_data_field_place_of_birth
# field_data_field_place_of_death
# field_data_field_rome_address
# field_data_field_rome_poi
# field_data_field_rome_studio
# field_data_field_subtitle
# field_data_field_teacher_in_nl
# field_data_field_teacher_in_rome
# field_data_field_years_in_rome
# field_data_field_years_rome


export MYSQL_PWD=""