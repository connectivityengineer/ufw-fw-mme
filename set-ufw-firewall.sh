#!/bin/bash

set -euo pipefail

# Get the Cloudflare IPs
curl -s https://www.cloudflare.com/ips-v4 -o /tmp/cloudflare_ips_$$
echo "" >> /tmp/cloudflare_ips_$$
curl -s https://www.cloudflare.com/ips-v6 >> /tmp/cloudflare_ips_$$

# Reset the firewall to clean stuff.
ufw --force reset

# Make sure the firewall is enabled and started, as the above command
# stops it.
ufw enable

# Whitelist some ips here 
ufw allow from 45.41.213.0/24 comment 'UkraineSource netblock'
ufw allow from 45.12.1.0/24  comment 'UkraineSource  netblock'
ufw allow from 62.182.85.105 comment 'UkraineSource specific server'
ufw allow from 45.12.1.23 comment 'UkraineSource specific server'
ufw allow from 169.197.88.0/24 comment 'NYC DC Cluster Members'
ufw allow from 23.120.253.0/24 comment 'OUR OWN IP RANGE' 
ufw allow from 100.64.0.0/10 comment 'Our Internal Range'


# Allow SSH.
ufw allow 1022  comment 'our ssh'

#allow ports with the XUI service 
ufw allow 80
ufw allow 443
ufw allow 8080 

# Allow traffic from Cloudflare IPs on all ports.
for ip in $(cat /tmp/cloudflare_ips_$$)
do
  ufw allow proto tcp from $ip comment 'Cloudflare'
done

#  Block specific known networks that have hammered our systems 

ufw deny from 74.125.0.0/16 comment 'ddos from google cloud'
ufw deny from 142.250.0.0/15 comment 'ddos from google cloud'
ufw deny from 172.217.0.0/16 comment 'ddos from google cloud'
ufw deny from 173.194.0.0/16 comment 'ddos from google cloud'


# Reload ufw.
ufw reload > /dev/null

# Show the rules to verify it worked.
ufw status numbered
