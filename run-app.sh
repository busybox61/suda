#!/bin/bash


PORT=80
DATABASE='On'
DATA_PATH=
PUBLIC_PATH=
APP_PATH=
MASTER='Off'
INIT='Off'
UPGRADE='Off'
APP_HASH_NAME=
RESTART_APP=false
IS_SPK=false
BRANCH='dev'

function print_usage() {
    echo 'Usage:'
    echo '  run-app.sh [options] app-path'
    echo '  options:'
    echo '    --init         clear data and init app'
    echo '    --upgrade      upgrade suda system'
    echo '    --database     disable docker database'
    echo '    --master       set use master branch(default:dev)'
    echo '    --public       set public path to local'
    echo '    --restart      restart app'
    echo '    -p --port      set export port'
    echo '    -d --data      set data path to local'
}

if [ $# = 0 ];
then
  print_usage
  exit 0
fi

ARGS=`getopt -o p:d: --long init,restart,upgrade,database,master,port:,data:,public: -n 'run-app.sh' -- "$@"`

eval set -- "${ARGS}"

while true
do
  case "$1" in
    --init)
      echo 'init apk'
      INIT='On'
      shift
      ;;
    --database)
      echo 'disable docker database'
      DATABASE='Off'
      shift
      ;;
    --upgrade)
      UPGRADE='On'
      shift
      ;;
    --restart)
      RESTART_APP=true
      shift
      ;;
    --master)
      MASTER='On'
      BRANCH='master'
      shift
      ;;
    -p|--port)
      echo "set port 80 export to $2"
      PORT="$2"
      shift 2
      ;;
    -d|--data)
      echo "use data path $2"
      DATA_PATH="$2"
      shift 2
      ;;
    --public)
      echo "use public path $2"
      PUBLIC_PATH="$2"
      shift 2
      ;;
    --)
      case "$2" in
        "")
          echo 'empty app path'
          exit 2
          ;;
        *)
        APP_PATH="$2"
        echo "local app path $2"
        shift 2
      esac
      break
      ;;
    *)
      echo "unkown $1 args"
      exit 1
      ;;
  esac
done

# DOCKER=`which docker`

# if [ -z "$DOCKER" ];
# then
#   echo 'please install docker'
#   exit 2
# fi

CMDLINE=( -p "${PORT}:80" -e MASTER="$MASTER" -e LOCAL_DATABASE="$DATABASE" -e GIT_UPGRADE="$UPGRADE")
COPYPATH=

if [ ! -z "${DATA_PATH}" ];
then
  CMDLINE+=( -v "$DATA_PATH:/suda-app/runtime-data")
fi

if [ ! -z "${PUBLIC_PATH}" ];
then
  CMDLINE+=( -v "$PUBLIC_PATH:/suda-app/public")
fi

# if [ -f Dockerfile ]; then
#   docker build -t suda-system .
# fi

if [ -f "${APP_PATH}" ];
then
  APP_HASH_NAME=`md5sum $APP_PATH | awk '{print $1}'`
  COPYPATH="$APP_PATH $APP_HASH_NAME:/suda-app/app.spk"
  IS_SPK=true
else
  echo "$APP_PATH is not exist parse as dirname"
  CMDLINE+=( -v "$APP_PATH:/suda-app/app")
fi

function init_docker() {
   echo 'init docker'
   docker run -d --name $APP_HASH_NAME  ${CMDLINE[@]} dxkite/suda:latest 
}

if [ IS_SPK ]; then  
  APP_STARTED=`docker ps | grep "$APP_HASH_NAME" | grep 'Up' | awk '{ print $1 }'`
  APP_CON=`docker ps -a | grep "$APP_HASH_NAME" | awk '{ print $1 }'`
  # if init then clear
  if ( [ "$INIT" = 'On' ] || [ -z "$APP_CON" ] ); then
      if [ -z "$APP_CON" ]; then
        init_docker
      else
         echo 'clear docker'
         if [ ! -z "$APP_STARTED" ]; then
          docker stop "$APP_CON"
         fi
         docker rm "$APP_CON"
         init_docker
      fi
  fi
 
  echo 'copy spk to docker'
  docker cp $COPYPATH 
  
  APP_STARTED=`docker ps | grep "$APP_HASH_NAME" | grep 'Up' | awk '{ print $1 }'`
  APP_CON=`docker ps -a | grep "$APP_HASH_NAME" | awk '{ print $1 }'`

  if [ -z "$APP_STARTED" ]; then  
    echo "start ${APP_PATH}"
    docker start $APP_HASH_NAME
  else
    if [ $RESTART_APP = true ]; then
      echo "app ${APP_PATH} is restarted"
      if [ ! -z "$APP_STARTED" ]; then
        echo 'stop running docker'
        docker stop "$APP_CON"
      fi
      docker start $APP_HASH_NAME
    else
      echo "app ${APP_PATH} is started"
    fi
  fi
  if [ "$UPGRADE" = 'On' ]; then
    docker exec -it $APP_CON /bin/bash /suda-app/upgrade.sh "$BRANCH"
  fi
  # docker attach $APP_CON
else # is path
  docker run -d ${CMDLINE[@]}  dxkite/suda:latest
fi




