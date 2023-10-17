#!/bin/bash

# Function to check if a command was successful
check_success() {
    if [[ $? -ne 0 ]]; then
        echo "An error occurred. Exiting."
        exit 1
    fi
}

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y
check_success

# Install TinyProxy
sudo apt install tinyproxy -y
check_success

# Modify the TinyProxy configuration to allow your IP
# Replace "your_ip_address" with your actual IP address
echo "Allow 0.0.0.0/0" | sudo tee /etc/tinyproxy/tinyproxy.conf
check_success

# Restart TinyProxy to apply the changes
sudo /etc/init.d/tinyproxy restart
check_success

echo "Proxy setup completed. Configure your applications to use the proxy at $(curl -s ifconfig.me):8888"
