#!/bin/bash
createDependentDirs()
{
    
  if [ ! -e $1 ]
  then
    echo "Directory $1 does not exist"
    return -1
  else
    echo "Directory $1 exists"
    echo "$1"
    read chartname < <(awk '/^name: .*$/{print $2}' $1/Chart.yaml)
    awk '/^- name: .*$/{print $3}' $1/requirements.yaml | while read line; do
        echo $line
        (cd $1 && mkdir ../$line)
        if echo $line | grep 'wso2-am'; then
            (cd $1/../$line && \
            cp -r $WORKDIR/wso2-helm-charts/wso2-am/* . && \
            sed -i.bak "s/wso2-am/$line/" Chart.yaml && \
            rm -f Chart.yaml.bak)
        else
            (cd $1/../$line && \
            cp -r $WORKDIR/wso2-helm-charts/wso2-is-km/* .)
        fi
    done
  fi
}

BASEDIR=$PWD
if [ -z "$1" ]; then
  echo "no workdir provided"
  return -1
fi
if [ -z "$2" ]; then
  echo "no helm version provided"
  return -1
fi
rm -rf $BASEDIR/$1
mkdir -p $BASEDIR/$1
WORKDIR=$BASEDIR/$1
export HELMVERSION=$2
mkdir $WORKDIR/wso2-helm-charts $WORKDIR/wso2-helm-deploy-charts
cp -r $BASEDIR/wso2-am $WORKDIR/wso2-helm-charts
cp -r $BASEDIR/wso2-is-km $WORKDIR/wso2-helm-charts
cp -r $BASEDIR/wso2-composite $WORKDIR/wso2-helm-deploy-charts

cd $WORKDIR/wso2-helm-deploy-charts 
for d in */*-subnet/*/; 
do
    createDependentDirs $d
done


find $WORKDIR/wso2-helm-deploy-charts -type f -name "Chart.yaml" -print0 | xargs -0 sed -i.bak s/"version: VERSION_PLACEHOLDER"/"version: $HELMVERSION"/g
find $WORKDIR/wso2-helm-deploy-charts -type f -name "requirements.yaml" -print0 | xargs -0 sed -i.bak s/"version: VERSION_PLACEHOLDER"/"version: $HELMVERSION"/g
find $WORKDIR/wso2-helm-deploy-charts -type f -name "requirements.yaml.bak" -exec rm -f {} \;
find $WORKDIR/wso2-helm-deploy-charts -type f -name "Chart.yaml.bak" -exec rm -f {} \;
