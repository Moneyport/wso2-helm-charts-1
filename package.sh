#!/bin/bash

#
# Script to Package all charts, and created an index.yaml in $1 directory
#

# Function to check the last command’s result exited with a value of 0, otherwise the script will exit with a 1
function checkCommandResult () {
   if [ $? -eq 0 ]; then
       shopt -s xpg_echo
       echo \\n
   else
       echo “Command failed...exiting. Please fix me!“;
       exit 1
   fi
}
if [ -z "$1" ]; then
  echo "no SRCDIR provided"
  return -1
fi
if [ -z "$2" ]; then
  echo "no REPODIR provided"
  return -1
fi
BASEDIR=$PWD
SRCDIR=$BASEDIR/$1
REPODIR=$BASEDIR/$2
if [ ! -e $REPODIR ]; then
  mkdir -p $REPODIR
fi

cd $SRCDIR/wso2-helm-deploy-charts/wso2-composite/external-subnet

echo “Packaging wso2-master-ext-composite...”
helm package -u -d $REPODIR ./wso2-master-ext-composite
checkCommandResult

cd $SRCDIR/wso2-helm-deploy-charts/wso2-composite/internal-subnet
echo “Packaging wso2-master-int-composite...”
helm package -u -d $REPODIR ./wso2-master-int-composite
checkCommandResult

cd $REPODIR

echo “Creating Helm repo index...”
helm repo index .
#checkCommandResult

shopt -s xpg_echo
echo “\
Packaging completed.\\n \
Ensure you check the output for any errors. \\n \
Ignore any http errors when connecting to \“local\” chart repository.\\n \
\\n \
Run the following command to serve a local repository: helm serve --repo-path $1 \\n \
\\n \
Happy Helming! \
""
