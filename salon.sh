#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICE_MENU(){
if [[ $1 ]]
then
  echo -e "\n$1"
fi

AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
do  
  echo "$SERVICE_ID) $NAME"
done

#ask which service 
#echo -e "\nWhich service would you like?"

read SERVICE_ID_SELECTED 

if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then
  SERVICE_MENU "Please enter a valid service number."

  else
    SERVICE_REQUIRED_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    if [[ -z $SERVICE_REQUIRED_ID ]]
    then
      SERVICE_MENU "Please enter a valid service number."
    fi
  
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    # if customer doesn't exist
      if [[ -z $CUSTOMER_NAME ]]
        then
          # get new customer name
          echo -e "\nWhat's your name?"
          read CUSTOMER_NAME
        
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
      fi
    
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    

    echo -e "\nWhat time appointment would you like?"
    read SERVICE_TIME

    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

SERVICE_NAME_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_REQUIRED_ID")

echo -e "\nI have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."

fi    


}

SERVICE_MENU
