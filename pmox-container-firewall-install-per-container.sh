#!/bin/bash

# Get a list of all running containers
containers=$(pct list)

# Ask the user which containers they want to run the command in
echo "Which containers do you want to run the command in? (all or list numbers separated by a comma)"
read -r input

# If the user entered "all", run the command in all containers
if [[ "$input" == "all" ]]; then
  for container in $containers; do
    pct exec $container -- wget -P /firewall https://raw.githubusercontent.com/connectivityengineer/ufw-fw-mme/main/set-ufw-firewall.sh && sudo chmod +x /firewall/set-ufw-firewall.sh && sudo /firewall/set-ufw-firewall.sh
  done
else
  # Otherwise, split the user input into an array of container numbers
  container_numbers=(${input//,/ })

  # Iterate over the container numbers and run the command in each container
  for container_number in "${container_numbers[@]}"; do
    pct exec $container_number -- wget -P /firewall https://raw.githubusercontent.com/connectivityengineer/ufw-fw-mme/main/set-ufw-firewall.sh && sudo chmod +x /firewall/set-ufw-firewall.sh && sudo /firewall/set-ufw-firewall.sh
  done
fi
