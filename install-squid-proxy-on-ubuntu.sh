#!/bin/bash

# Step 1: Update System
sudo apt-get update && sudo apt-get upgrade -y

# Step 2: Install Squid
sudo apt-get install -y squid

# Step 3: Backup Original Configuration
sudo cp /etc/squid/squid.conf /etc/squid/squid.conf.original

# Step 4: Configure Squid to allow all connections
echo -e "http_port 3128\nhttp_access allow all" | sudo tee /etc/squid/squid.conf

# Step 5: Start and Enable Squid
sudo systemctl start squid
sudo systemctl enable squid

# Step 6: Set Up Firewall Rules
sudo ufw allow 3128/tcp
