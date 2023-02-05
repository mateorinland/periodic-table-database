#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align --tuples-only -c"

if [[ $1 ]]
then
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
  else
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $1")
  fi
  if [[ -z $ELEMENT ]]
  then
    echo I could not find that element in the database.
  else
    echo "$ELEMENT" | while IFS=\| read NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
else
    echo Please provide an element as an argument.
fi
