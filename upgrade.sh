#!/bin/bash

BRANCH=$1

if [ "$BRANCH" = 'master' ]; then
  rm -rf /suda-app/suda
  cd /suda-app/suda-git
  git checkout master
  echo 'checkout to master'
  git pull -f origin master
  cp -R /suda-app/suda-git /suda-app/suda
else
  rm -rf /suda-app/suda
  cd /suda-app/suda-git
  git checkout dev
  echo 'checkout to dev'
  git pull -f origin dev
  cp -R /suda-app/suda-git /suda-app/suda
fi


cp -R /suda-app/suda/system/resource/project/public /suda-app

sed -i 's/\/opt\/lampp\/htdocs/\/suda-app\/public/g' /opt/lampp/etc/httpd.conf
sed -i "/'SYSTEM'/d" /suda-app/public/dev.php
sed -i "/'SYSTEM'/d" /suda-app/public/index.php
sed -i "/'DATA_DIR'/d" /suda-app/public/dev.php
sed -i "/'DATA_DIR'/d" /suda-app/public/index.php
sed -i '3idefine("DATA_DIR", "/suda-app/runtime-data");' /suda-app/public/dev.php
sed -i '3idefine("DATA_DIR", "/suda-app/runtime-data");' /suda-app/public/index.php
sed -i '3idefine("SYSTEM", "/suda-app/suda/system");' /suda-app/public/dev.php
sed -i '3idefine("SYSTEM", "/suda-app/suda/system");' /suda-app/public/index.php
