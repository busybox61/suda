#!/bin/bash

if [ "$MASTER" = 'On' ]; then
  rm -rf /suda-app/suda
  cd /suda-app/suda-git
  git checkout master
  echo 'checkout to master'
    if [ "$GIT_UPGRADE" = 'On' ]; then
        echo 'git pull origin master'
        git pull -f origin master
    fi
  cp -R /suda-app/suda-git /suda-app/suda
else
  rm -rf /suda-app/suda
  cd /suda-app/suda-git
  git checkout dev
  echo 'checkout to dev'
    if [ "$GIT_UPGRADE" = 'On' ]; then
    echo 'git pull origin dev'
    git pull -f origin dev
    fi
  cp -R /suda-app/suda-git /suda-app/suda
fi

cd /suda-app/suda-git

git log -n 1

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

echo 'init system ok'

if [ -f "/suda-app/app.spk" ]; then
    echo 'unzip suda package'
    unzip -o -q /suda-app/app.spk -d /suda-app/app
fi

# check app manifast
if [ ! -f "/suda-app/app/manifast.json" ];then
  echo 'no app avaiable'
  exec "$@"
else

  if [ "$LOCAL_DATABASE" = 'On' ]; then
    # init database password
    mkdir -p /suda-app/runtime-data/runtime
    chmod a+rw -R /suda-app/runtime-data/runtime
    echo '<?php return ["passwd" => "","host"=>"127.0.0.1"]; ' > /suda-app/runtime-data/runtime/database.config.php
  fi

  mkdir -p /suda-app/runtime-data/logs/
  touch /suda-app/runtime-data/logs/latest.log

  chown -R daemon:daemon /suda-app/runtime-data
  chown -R daemon:daemon /suda-app/public
  
  if [ "$LOCAL_DATABASE" = 'On' ]; then
  lampp startmysql
  fi
  
  lampp startapache

  tail -f /suda-app/runtime-data/logs/latest.log
  # tail -f /opt/lampp/logs/access_log
fi


