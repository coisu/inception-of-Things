#!/bin/bash

echo "Setting VirtualBox machine folder to /goinfre/"
VBoxManage setproperty machinefolder /goinfre/$(whoami)/VirtualBoxVMs

# Add Debian box
echo "Adding bento/debian-11 box if not already installed..."
vagrant box list | grep -q "bento/debian-11" || vagrant box add bento/debian-11

# Run Vagrant
# echo "Running vagrant up..."
# vagrant up
