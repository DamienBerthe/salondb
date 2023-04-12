#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICES=$($PSQL "SELECT name, service_id FROM services")
MAIN_MENU(){
  echo "$SERVICES" | while read SERVICE BAR SERVICE_ID
  do
    echo "$SERVICE_ID) $SERVICE"
  done
  read SERVICE_ID_SELECTED
  SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'");
  if [[ -z $SERVICE_SELECTED ]]
  then 
    MAIN_MENU
  else
    GET_PHONE
    EXIST_PHONE=$($PSQL "SELECT exists (SELECT true FROM customers WHERE phone='$CUSTOMER_PHONE')");
    if [[ $EXIST_PHONE = ' t'  ]]
    then 
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'");
    else
      GET_NAME
    fi
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'");
    GET_TIME
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
    echo "I have put you down for a $SERVICE_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}


GET_PHONE(){
  echo "What's your phone number?"
  read CUSTOMER_PHONE
  if [[ ! $CUSTOMER_PHONE =~ ^[0-9]{3}-[0-9]{3}-[0-9]{4}$ ]]
  then
    echo 'kek'
  fi
}

GET_NAME(){
  echo "What's your name?"
  read CUSTOMER_NAME
  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
}

GET_TIME(){
  echo "What time would you like your$SERVICE_SELECTED,$CUSTOMER_NAME?"
  read SERVICE_TIME
}

MAIN_MENU