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

# Modify the TinyProxy configuration to allow all IP addresses, set the port,
# specify the user and group under which TinyProxy will run,
# set the maximum number of clients, and set the number of servers to start
sudo bash -c "cat > /etc/tinyproxy/tinyproxy.conf" << EOL
User tinyproxy
Group tinyproxy
Port 8888
Allow 0.0.0.0/0
MaxClients 100
StartServers 10
EOL
check_success

# Create the tinyproxy user and group, if they don't already exist
if ! id -u tinyproxy >/dev/null 2>&1; then
    sudo addgroup --system tinyproxy
    sudo adduser --system --no-create-home --ingroup tinyproxy tinyproxy
fi
check_success

# Create a custom systemd service file for TinyProxy
sudo bash -c "cat > /etc/systemd/system/tinyproxy.service" << EOL
[Unit]
Description=Tinyproxy lightweight HTTP Proxy
After=network.target

[Service]
User=tinyproxy
Group=tinyproxy
ExecStart=/usr/sbin/tinyproxy -d

[Install]
WantedBy=multi-user.target
EOL
check_success

# Reload systemd to recognize the new service file, then start TinyProxy
sudo systemctl daemon-reload
check_success

sudo systemctl start tinyproxy
check_success

echo "Proxy setup completed. Configure your applications to use the proxy at $(curl -s ifconfig.me):8888"
