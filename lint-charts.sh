#!/bin/bash

#
# Script to update all Helm Chart Dependencies
#

echo "Linting all Charts..."

# Function to check the last command's result exited with a value of 0, otherwise the script will exit with a 1
function checkCommandResult () {
    if [ $? -eq 0 ]; then
        echo ""
    else
        echo "lintdate failed...exiting. Please fix me!";
        exit 1
    fi
}

BASEDIR=$PWD
SRCDIR=$BASEDIR/$1

echo "Removing old charts..."
find ./ -name "charts"| xargs rm -Rf
find ./ -name "tmpcharts"| xargs rm -Rf

cd $SRCDIR/wso2-helm-deploy-charts/wso2-composite/external-subnet

echo "Linting wso2-master-ext-composite..."
helm lint ./wso2-master-ext-composite
checkCommandResult

cd $SRCDIR/wso2-helm-deploy-charts/wso2-composite/internal-subnet
echo "Linting wso2-master-int-composite..."
helm lint ./wso2-master-int-composite
checkCommandResult



echo "\
Chart linting completed.\n \
Ensure you check the output for any errors. \n \
Ignore any http errors when connecting to \"local\" chart repository.\n \
\n \
Happy Helming!
"