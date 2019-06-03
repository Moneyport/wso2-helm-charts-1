#!/bin/bash

#
# Script to index.yaml in $1 directory
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
if [ -z "$1" ]; then
  echo "no dir provided to index"
  return -1
fi
cd $1
echo “Creating Helm repo index...”
helm repo index .
checkCommandResult

