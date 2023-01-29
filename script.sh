#!/bin/bash

# Replace <insert-webhook-url-here> with the Slack webhook URL
webhook_url="<insert-webhook-url-here>"

# Replace <insert-email-address-here> with the email address to send notifications to
email="<insert-email-address-here>"

# Replace <insert-csv-file-name-here> with the name of the CSV file containing the domain names
csv_file="<insert-csv-file-name-here>"

# Read the domains from the CSV file
while IFS= read -r line; do
  domain=$line
  
  # Get the SSL certificate expiration date for the domain
  expiry_date=$(echo | openssl s_client -servername $domain -connect $domain:443 2>/dev/null | openssl x509 -noout -dates | grep notAfter | awk -F'=' '{print $2}')
  
  if [ -z "$expiry_date" ]; then
    echo "$domain does not have an SSL certificate"
  else
    # Convert the SSL certificate expiration date to a UNIX timestamp
    expiry_timestamp=$(date -d "$expiry_date" +%s)
    
    # Get the current date and convert it to a UNIX timestamp
    current_date=$(date +%s)
    
    # Calculate the number of days left before the SSL certificate expires
    days_left=$(( (expiry_timestamp - current_date) / 86400 ))
    
    # Display the domain, SSL certificate expiration date, and number of days left
    echo "$domain,$expiry_date,$days_left days left"
    
    # Check if the SSL certificate will expire in 30, 15, or 1 day
    if [[ $days_left -eq 30 ]] || [[ $days_left -eq 15 ]] || [[ $days_left -eq 1 ]]; then
      # Send a notification via email
      echo "SSL certificate for $domain will expire in $days_left days" | mail -s "SSL Certificate Expiration: $domain" $email
      
      # Send a notification via Slack
      curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"SSL certificate for $domain will expire in $days_left days\"}" $webhook_url
      
      # Display a message indicating that a notification was sent
      echo "Notification sent for $domain"
    fi
  fi
done < $csv_file

# Slack message indicating script ran successfully
curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"SSL certificate expiration check ran successfully.\"}" $webhook_url

