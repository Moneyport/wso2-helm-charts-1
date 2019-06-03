#!/bin/bash

#
# Script to index.yaml in current directory
#

# Function to check the last command’s result exited with a value of 0, otherwise the script will exit with a 1
function checkCommandResult () {
   if [ $? -eq 0 ]; then
       shopt -s xpg_echo
       echo “Helm executed successfully“;
   else
       echo “Command failed...exiting. Please fix me!“;
       exit 1
   fi
}


echo “Creating Helm repo index...”
helm repo index .
checkCommandResult

