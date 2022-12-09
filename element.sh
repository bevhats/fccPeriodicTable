#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
   #check if parameter is number
   if [[ ! $1 =~ ^[0-9]+$ ]]
   then
      # get the atomic number
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1' or symbol = '$1'")
   else
      # get the atomic number
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
   fi

   # if not found
   if [[ -z $ATOMIC_NUMBER ]]
   then
      echo "I could not find that element in the database."
   else
      # get data 
      ELEMENT_RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties  USING (atomic_number) LEFT JOIN types USING (type_id) WHERE atomic_number = $ATOMIC_NUMBER")

      echo -e $ELEMENT_RESULT | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
      do
         echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
   fi
else
   echo "Please provide an element as an argument."
fi
