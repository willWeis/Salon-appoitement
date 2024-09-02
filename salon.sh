#! /bin/bash
psql --username=freecodecamp --dbname=salon -c "\q"
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"


# Main Menu Function
MAIN_MENU() {
  echo -e "\nHello and welcome you good day that is my name\n"
  
  while true; do
    echo -e "\nPlease select a service:\n"
    
    # Display services in the required format
    SERVICES=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT service_id, name FROM services ORDER BY service_id")
    echo "$SERVICES" | while read -r SERVICE_ID BAR NAME; do
      echo "$SERVICE_ID) $NAME"
    done
    
    # Read user input
    echo -e "\nEnter the service number"
    read SERVICE_ID_SELECTED

    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    
    # Handle user input
    case $SERVICE_ID_SELECTED in
      1) HOTLINE ; break;;
      2) HOTLINE ; break;;
      3) HOTLINE ; break;;
      *) echo "Invalid selection. Please try again.";;
    esac
  done
}

HOTLINE() {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  # Check if the customer exists
  CUSTOMER_NAME=$(psql --username=freecodecamp --dbname=salon -t -c "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_NAME ]]; then
    # Prompt for customer name if not found
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME

    # Insert new customer into the database
    psql --username=freecodecamp --dbname=salon -c "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')"
  fi

  echo -e "\nAt what time is your rendez-vous?"
  read SERVICE_TIME

  psql --username=freecodecamp --dbname=salon -c "INSERT INTO appointments(customer_id, service_id, time) VALUES((SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'), $SERVICE_ID_SELECTED, '$SERVICE_TIME')"

  echo  -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

# Call the Main Menu Function
MAIN_MENU

# Exit the script
exit 0
