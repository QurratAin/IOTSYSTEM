#!/bin/bash
# User Data Script for Grafana EC2 Instance

# Log all output to /var/log/user-data.log
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Update the system
echo "Updating system packages..."
sudo apt-get update -y

# Install prerequisites
echo "Installing prerequisites..."
sudo apt-get install -y apt-transport-https software-properties-common wget

# Add Grafana repository
echo "Adding Grafana repository..."
sudo mkdir -p /etc/apt/keyrings
wget -q -O - https://apt.grafana.com/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/grafana.gpg
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# Update package list and install Grafana
echo "Installing Grafana..."
sudo apt-get update -y
sudo apt-get install -y grafana

# Start and enable Grafana service
echo "Starting Grafana service..."
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# Optional: Install a Grafana plugin (e.g., AWS Timestream plugin)
echo "Installing Grafana AWS Timestream plugin..."
sudo grafana-cli plugins install grafana-timestream-datasource

# Optional: Configure Grafana (e.g., set admin password)
# echo "Setting Grafana admin password..."
# sudo grafana-cli admin reset-admin-password MySecurePassword

# Print Grafana version
echo "Grafana version:"
grafana-server -v

# Print Grafana service status
echo "Grafana service status:"
sudo systemctl status grafana-server

echo "Grafana installation and setup complete!"