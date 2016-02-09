#!/usr/bin/env bash

tables=$(MYSQL_PWD=hadrianus mysql -u hadrianus knir1102_live -N -s -e "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE 'field_data_field%';")

for table in $tables; do
  fieldname="${table:17:${#table}}"
  camelcase=$(echo "$fieldname" | sed -r 's/_([a-z])/\U\1/g' | sed -r 's/_(.)/\1/g')
  echo "$fieldname ($camelcase):"
  MYSQL_PWD=hadrianus mysql -u hadrianus knir1102_live -N -s -e "SELECT DISTINCT bundle FROM field_data_field_${fieldname};"
  echo
done

# actual_location (actualLocation):
# object

# address (address):
# person

# address_description (addressDescription):
# address

# alphabetical_name (alphabeticalName):
# person

# alternative_name (alternativeName):
# person

# bibliography (bibliography):
# group
# person

# body_2 (body2):
# page

# body_actual (bodyActual):
# locatie

# body_historic (bodyHistoric):
# locatie

# body_personal (bodyPersonal):

# body_represented (bodyRepresented):
# locatie

# collection (collection):
# object

# collection_inhabitants (collectionInhabitants):
# address

# collection_inhabitants_2 (collectionInhabitants2):
# address

# coords (coords):
# address
# locatie

# date_of_birth (dateOfBirth):
# person

# date_of_death (dateOfDeath):
# person

# dimensions (dimensions):
# object

# dutch_residence_after (dutchResidenceAfter):
# person

# dutch_residence_before (dutchResidenceBefore):
# person

# employment (employment):
# person

# group (group):
# person

# house_number (houseNumber):
# address

# house_owner (houseOwner):
# address

# icon (icon):
# locatie

# image (image):
# group
# object
# person

# inhabitant (inhabitant):
# field_collection_inhabitants

# inhabitant_2 (inhabitant2):
# field_collection_inhabitants_2

# inhabitant_period (inhabitantPeriod):
# field_collection_inhabitants
# field_collection_inhabitants_2

# inhabitant_reliability (inhabitantReliability):
# field_collection_inhabitants
# field_collection_inhabitants_2

# inhabitant_remarks (inhabitantRemarks):
# field_collection_inhabitants
# field_collection_inhabitants_2

# inhabitant_source (inhabitantSource):
# field_collection_inhabitants
# field_collection_inhabitants_2

# intro (intro):
# page

# intro_image (introImage):
# page

# life_and_death (lifeAndDeath):
# person

# location (location):
# object

# location_of_work_shown (locationOfWorkShown):
# object

# material_tagging (materialTagging):
# object

# neighbourhood (neighbourhood):

# open_popup (openPopup):
# group
# object
# person

# parish (parish):
# address

# patron (patron):

# period_end (periodEnd):
# object

# period_start (periodStart):
# object

# person (person):
# object

# place_of_birth (placeOfBirth):
# person

# place_of_death (placeOfDeath):
# person

# rome_address (romeAddress):
# person

# rome_poi (romePoi):
# person

# rome_studio (romeStudio):
# person

# street (street):
# address

# subtitle (subtitle):
# object
# person

# teacher_in_nl (teacherInNl):
# person

# teacher_in_rome (teacherInRome):
# person

# type (type):
# locatie

# websource (websource):
# object

# work_type_tagging (workTypeTagging):
# object

# years_in_rome (yearsInRome):
# group
# person

# years_rome (yearsRome):
# group
# person
