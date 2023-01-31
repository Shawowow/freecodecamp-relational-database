#!/bin/bash
PSQL="psql --tuples-only --username=freecodecamp --dbname=salon -c "
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?\n"
MAIN_MENU() {
  $PSQL "SELECT * FROM services;" | while IFS=" | " read SERVICE_ID SERVICE_NAME
  do
    if [[ ! -z $SERVICE_ID ]]
    then
      echo -e "$SERVICE_ID) $SERVICE_NAME"
    fi
  done
  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ ^[1-5]$ ]]
  then 
    echo -e "\n"I could not find that service. What would you like today?""
    MAIN_MENU 
  fi  
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER=$($PSQL "select * from customers where phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    $PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')"
  fi
  SERVICE=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
  echo -e "\nWhat time would you like your$SERVICE,$CUSTOMER_NAME?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  $PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')"
  echo -e "\nI have put you down for a$SERVICE at $SERVICE_TIME,$CUSTOMER_NAME."
}
MAIN_MENU
