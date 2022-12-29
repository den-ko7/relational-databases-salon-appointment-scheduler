#!/bin/bash 

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~~~Salon Appointment Scheduler~~~~\n"

MAIN_MENU(){

if [[ $1 ]]
then
  echo -e "\n$1"
fi

echo "How may I help you?"
echo "~~Available Services~~"
echo -e "\n1) full cut\n2) outline\n3) washing\n4) Exit"
# get service selection from customer
read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
1) BOOKING_MENU ;;
2) BOOKING_MENU ;;
3) BOOKING_MENU ;;
4) EXIT ;;
*) MAIN_MENU "Please select a valid service." ;;
esac

}

BOOKING_MENU(){

echo "booking menu $SERVICE_ID_SELECTED"
echo -e "\n Please enter you phone number"
# get customer phone number
read CUSTOMER_PHONE
echo "thanks $CUSTOMER_PHONE"

# try and find matching number
MATCH_CUSTOMER_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")

# if no match found then no customer exists
if [[ -z $MATCH_CUSTOMER_PHONE ]]
then
# get customer name
echo "Ok This is your first appointment. Please enter your name"
read CUSTOMER_NAME
# thank the customer
 echo "Thanks $CUSTOMER_NAME, your number on file is $CUSTOMER_PHONE"
# get appointment time
 echo "What time do you want to book your appointment?"
# get appointment time
 read SERVICE_TIME
# get service name
 SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
# confirm service time
echo " I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
# insert customer data into db
INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME' OR phone='$CUSTOMER_PHONE'")

INSERT_APPOINTMNENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
else

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME' OR phone='$CUSTOMER_PHONE'")

 echo "Thanks, we have your info from your last appointment, what time do you want to book your appointment?"

# get appointment time
read SERVICE_TIME
# get service name
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
# confirm service time
echo " I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
# insert appointment
INSERT_APPOINTMNENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")

 fi

}


EXIT(){

  echo "bye bye"

}

MAIN_MENU
