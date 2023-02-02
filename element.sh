#!/bin/bash
PSQL="psql --tuples-only --username=freecodecamp --dbname=periodic_table -t --no-align -c"
ELEMENT=
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]*$ ]]
  then
    ELEMENT=$($PSQL "select properties.atomic_number,atomic_mass,melting_point_celsius, boiling_point_celsius,name,type,symbol from properties full join elements on properties.atomic_number=elements.atomic_number full join types on properties.type_id=types.type_id where properties.atomic_number=$1;")
    if [[ ! -z $ELEMENT ]]
    then
      echo $ELEMENT | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS NAME TYPE SYMBOL
      do
      echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    else
      #echo $1
      echo "I could not find that element in the database."
    fi
  elif [[ $1 =~ ^[A-Z][a-z]$ || $1 =~ ^[A-Z]$ ]]
  then
    ELEMENT=$($PSQL "select properties.atomic_number,atomic_mass,melting_point_celsius, boiling_point_celsius,name,type,symbol from properties full join elements on properties.atomic_number=elements.atomic_number full join types on properties.type_id=types.type_id where symbol='$1';")
    if [[ ! -z $ELEMENT ]]
    then
      echo $ELEMENT | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS NAME TYPE SYMBOL
      do
    # echo $($PSQL "select properties.atomic_number,atomic_mass,melting_point_celsius, boiling_point_celsius,name,type,symbol from properties full join elements on properties.atomic_number=elements.atomic_number full join types on properties.type_id=types.type_id where symbol='$1';")
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    else
      #echo $1 
      echo "I could not find that element in the database."
    fi
  elif [[ $1 =~ ^[A-Z][a-z]*$ && ${#1} > 2 ]]
  then
    ELEMENT=$($PSQL "select properties.atomic_number,atomic_mass,melting_point_celsius, boiling_point_celsius,name,type,symbol from properties full join elements on properties.atomic_number=elements.atomic_number full join types on properties.type_id=types.type_id where name='$1';")
    if [[ ! -z $ELEMENT ]]
    then
      echo $ELEMENT | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS NAME TYPE SYMBOL
      do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    else
      #echo $1
      echo "I could not find that element in the database."
    fi
  else
    #echo $1
    echo "I could not find that element in the database."
  fi
fi
