#!/bin/bash

# Step 1: Update System
sudo apt-get update && sudo apt-get upgrade -y

# Step 2: Install Squid and Apache Utils
sudo apt-get install -y squid apache2-utils

# Step 3: Backup Original Configuration
sudo cp /etc/squid/squid.conf /etc/squid/squid.conf.original

# Step 4: Ask for Username and Password
read -p "Enter a username for the proxy: " proxy_username
read -sp "Enter a password for the proxy: " proxy_password
echo # Newline for better formatting

# Step 5: Create User for Proxy Authentication
echo $proxy_password | sudo htpasswd -i -c /etc/squid/passwords $proxy_username

# Step 6: Configure Squid to require authentication
auth_configuration="\
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwords\n\
auth_param basic realm proxy\n\
acl authenticated proxy_auth REQUIRED\n\
http_access allow authenticated\n\
http_port 3128"
echo -e $auth_configuration | sudo tee /etc/squid/squid.conf

# Step 7: Start and Enable Squid
sudo systemctl start squid
sudo systemctl enable squid

# Step 8: Set Up Firewall Rules
sudo ufw allow 3128/tcp
