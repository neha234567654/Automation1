#!/bin/bash

# Check if Linode API token is set
#LINODE_API_TOKEN=$1

# Get the Linode ID from the first argument
#linode_id="$2"


# Construct the API request URL
#api_url="https://api.linode.com/v4/linode/instances/$2"

# Set headers with your Linode API token
#headers="Authorization: Bearer $LINODE_API_TOKEN"

# Send a GET request using curl and capture the response
#response=$(curl -s -H "$headers" "$api_url")
terraform init
terraform plan
terraform apply

# Convert the JSON response to a readable format
 ipv4s=$(cat terraform.tfstate | grep "\bip_address\b" | awk '{print $2}' | awk '{gsub(/\"/,"")}1' | awk '{gsub(/\n/,"")}1'| awk '{gsub(/,/,"")}1') 
 #echo $ipv4s 

sleep 60

for word in $ipv4s; do
    echo $word
    echo "login in --------------------- $word"
    ssh -f -i ~/.ssh/id_rsa root@$word "/usr/bin/python3 /usr/local/bin/locust --headless --csv csvstats$word -f /root/load-generator/locustBouttique.py --host=http://172.233.166.98 > /dev/null 2>&1 &" 
done



sleep 60



for word in $ipv4s; do
    echo $word
    scp -f -i ~/.ssh/id_rsa root@${word}:/root/csvstats${word}_exceptions.csv ./
    scp -f -i ~/.ssh/id_rsa root@${word}:/root/csvstats${word}_failures.csv ./
    scp -f -i ~/.ssh/id_rsa root@${word}:/root/csvstats${word}_stats.csv ./
    scp -f -i ~/.ssh/id_rsa root@${word}:/root/csvstats${word}_stats_history.csv ./
done

terraform destroy