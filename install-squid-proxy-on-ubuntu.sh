#!/bin/bash

# Function to check if a command was successful
check_success() {
    if [[ $? -ne 0 ]]; then
        echo "An error occurred. Exiting."
        exit 1
    fi
}

# Install TinyProxy
sudo apt-get install tinyproxy -y
check_success

# Modify the TinyProxy configuration to allow your IP subnet
# Replace "123.456.789.1/24" with your actual IP subnet
echo "Allow 84.106.129.108/32" | sudo tee -a /etc/tinyproxy/tinyproxy.conf
check_success

# Add a new crontab to restart TinyProxy daily at 10pm
# Note: This script assumes that the user has permission to edit the crontab without needing the 'root' user.
(crontab -l 2>/dev/null; echo "0 22 * * * service tinyproxy restart") | crontab -
check_success

# Open port 8888
sudo /sbin/iptables -I INPUT -p tcp --dport 8888 -m state --state NEW,ESTABLISHED -j ACCEPT
sudo /sbin/iptables -I OUTPUT -p tcp --sport 8888 -m state --state ESTABLISHED -j ACCEPT
check_success

# Restart TinyProxy
sudo service tinyproxy stop
sudo service tinyproxy start
check_success

echo "TinyProxy setup completed. Your proxy is now running on port 8888."
