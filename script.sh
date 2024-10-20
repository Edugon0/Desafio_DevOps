#!/bin/bash

echo "Update the server"
echo "------------------------"
sudo apt-get update
sudo apt-get upgrade -y

echo "Install Nginx"
echo "------------------------"
sudo apt-get install nginx -y

echo "Starting Nginx"
echo "------------------------"
sudo systemctl start nginx

echo "Enable Nginx to start on boot"
echo "------------------------"
sudo systemctl enable nginx
