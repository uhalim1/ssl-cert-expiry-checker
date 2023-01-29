Overview
This is a bash script that checks the expiration dates of SSL certificates for a list of domains and sends notifications via email and Slack 30, 15, and 1 day prior to expiration. It also displays the results after the script has run, including domains without an SSL certificate.

Requirements
openssl
curl
mail (for sending email notifications)
Slack account (for sending Slack notifications)
Usage
Clone the repository: git clone https://github.com/<username>/ssl-cert-expiry-checker.git
Replace <insert-webhook-url-here> in the script with the Slack webhook URL.
Replace <insert-email-address-here> in the script with the email address to send notifications to.
Replace <insert-csv-file-name-here> in the script with the name of the CSV file containing the domain names. The CSV file should contain one domain per line, with the domain name as the only value in each line.
Make the script executable: chmod +x ssl-cert-expiry-checker.sh
Run the script: ./ssl-cert-expiry-checker.sh
Contributions
Contributions are welcome. If you would like to contribute, please fork the repository and make your changes. Once you are ready, create a pull request for review.

License
This project is licensed under the MIT License.




