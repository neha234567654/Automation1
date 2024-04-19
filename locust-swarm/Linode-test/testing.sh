#!/bin/bash

# Get the output of terraform state list
terraform_state_output=$(terraform state list)

# Loop through each line of the output
while read -r line; do
  # Check if the line starts with 'linode_instance.' (assuming that's how your Linode instances are named)
  if [[ $line =~ ^linode_instance\. ]]; then
    # Extract the instance name (assuming it's the part after the '.')
    instance_name=${line##*.}
    echo "Found Linode instance: $instance_name"

    # **WARNING:** This script does not access or display any private information about the Linode instances.
    # Terraform state files by default do not store sensitive information like access keys or IP addresses.
    # If your Terraform configuration stores sensitive data, it's important to handle it securely and avoid echoing it in scripts.
  fi
done <<< "$terraform_state_output"