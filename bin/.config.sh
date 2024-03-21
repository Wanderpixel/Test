#!/usr/bin/env bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

#######################################
## Configuration
#######################################

READLINK='readlink'
unamestr=`uname`
if [ "$unamestr" == 'FreeBSD' -o "$unamestr" == 'Darwin'  ]; then
  READLINK='greadlink'
fi

if [ -z "`which $READLINK`" ]; then
    echo "[ERROR] $READLINK not installed"
    echo "        make sure coreutils are installed"
    echo "        MacOS: brew install coreutils"
    exit 1
fi

SCRIPT_DIR=$(dirname "$($READLINK -f "$0")")
ROOT_DIR=$($READLINK -f "$SCRIPT_DIR/../")

BACKUP_DIR=$($READLINK -f "$ROOT_DIR/backup")
SHOPWARE_DIR=$($READLINK -f "$ROOT_DIR/app/shopware")
PUBLIC_DIR="$SHOPWARE_DIR/public"
BACKUP_MYSQL_FILE='mysql.sql.bz2'
BACKUP_MEDIA_FILE='media.zip'

#######################################
## Functions
#######################################

errorMsg() {
	echo "[ERROR] $*"
}

logMsg() {
	echo " * $*"
}

sectionHeader() {
	echo "*** $* ***"
}

execInDir() {
    echo "[RUN :: $1] $2"

    sh -c "cd \"$1\" && $2"
}

dockerContainerId() {
     CONTAINER_NAME="${COMPOSE_PROJECT_NAME}_$1_1"
     echo "$(docker ps -aqf "name=${CONTAINER_NAME}")"
}

dockerExec() {
    docker exec -i "$(dockerContainerId app)" "$@"
}

dockerExecUser() {
    docker exec -i -u application "$(dockerContainerId app)" "$@"
}

dockerExecMySQL() {
    docker exec -i "$(dockerContainerId mysql)" "$@"
}

dockerExecKeycloakSQL() {
	docker exec -i "$(dockerContainerId keycloakdb)" "$@"
}

dockerCopyFrom() {
    PATH_DOCKER="$1"
    PATH_HOST="$2"
    docker cp "$(dockerContainerId app):${PATH_DOCKER}" "${PATH_HOST}"
}

dockerCopyTo() {
    PATH_HOST="$1"
    PATH_DOCKER="$2"
    docker cp "${PATH_HOST}" "$(dockerContainerId app):${PATH_DOCKER}"
}
