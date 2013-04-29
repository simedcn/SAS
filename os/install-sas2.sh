#!/bin/sh

sas_id=2

echo "-----------------------------"
echo "Installation script for SAS-${sas_id}"
echo "-----------------------------"

echo "Copying configuration files..."
sudo cp sysctl.conf /etc/sysctl.conf
sudo cp etc-conf.d-network /etc/conf.d/network
sudo cp etc-conf.d-lm_sensors /etc/conf.d/lm_sensors

echo "Configuring NIC device names based on known MAC addresses..."
sudo cp 10-network-sas${sas_id}.rules /etc/udev/rules.d/10-network.rules

echo "Setting up network-configuration service..."
sudo cp network-sas${sas_id}.service /etc/systemd/system/network.service

echo "Enabling services..."
sudo systemctl enable network
sudo systemctl enable lm_sensors
sudo systemctl enable sbc_info
echo "    Note: you will also need to run 'make install' for the sbc_info executable!"

echo "-----------------------------"
echo "Installation complete; reboot the computer!"
echo "-----------------------------"