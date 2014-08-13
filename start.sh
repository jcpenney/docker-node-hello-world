#!/bin/bash

#####################################################################
# Functions #
#####################################################################

function timestamp {
  date +%s
}


#####################################################################
# Variables #
#####################################################################

PROJECT_ROOT=$(pwd) # $(cd `dirname ${0}`; pwd)

MONGO_DOCKERFILE_PATH=$PROJECT_ROOT/mongo
MONGO_IMAGE_NAME=jcpinnovation/hello-world-mongo
MONGO_CONTAINER_NAME=mongo_$(timestamp)
MONGO_HOST_DATA_DIR=$PROJECT_ROOT/mongo/data
MONGO_CONTAINER_DATA_DIR=/db
MONGO_HOST_PORT=27017
MONGO_CONTAINER_PORT=27017

NODE_DOCKERFILE_PATH=$PROJECT_ROOT/app
NODE_IMAGE_NAME=jcpinnovation/hello-world-node
NODE_CONTAINER_NAME=node_$(timestamp)
NODE_HOST_PORT=49160
NODE_CONTAINER_PORT=8080

VARNISH_DOCKERFILE_PATH=$PROJECT_ROOT/varnish
VARNISH_IMAGE_NAME=jcpinnovation/hello-world-varnish
VARNISH_CONTAINER_NAME=varnish_$(timestamp)
VARNISH_HOST_PORT=80
VARNISH_CONTAINER_PORT=80

SKIP_BUILD_IMAGES=false

# https://www.mkssoftware.com/docs/man1/getopts.1.asp
while getopts 's' flag; do
  case "${flag}" in
    s) SKIP_BUILD_IMAGES=true ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

COLOR_RED=$'\e[1;31m'
COLOR_GREEN=$'\e[1;32m'
COLOR_YELLOW=$'\e[1;33m'
COLOR_BLUE=$'\e[1;34m'
COLOR_MAGENTA=$'\e[1;35m'
COLOR_CYAN=$'\e[1;36m'
COLOR_WIPE=$'\e[0m'


#####################################################################
# Prepration #
#####################################################################

{
  (boot2docker &> /dev/null) && {
    # if [ $(boot2docker status) = 'running' ]; then
    #   printf "\n${COLOR_BLUE}Boot2Docker is already running ${COLOR_WIPE} \n"
    # else
      printf "\n${COLOR_BLUE}Attempting to (re)start docker with boot2docker ${COLOR_WIPE} \n"
      boot2docker stop
      boot2docker start --disksize=60000
      export DOCKER_HOST=tcp://$(boot2docker ip 2>/dev/null):2375
      boot2docker ssh 'sudo echo "nameserver 8.8.8.8" > /etc/resolv.conf; sudo /etc/init.d/docker restart; exit'
      sleep 3
      printf "\n${COLOR_GREEN}Successfully started Docker ${COLOR_WIPE} \n\n"
    # fi
  }
} || {
  printf "\n${COLOR_RED}Could not run boot2docker command ${COLOR_WIPE} \n\n"
}

if [ $(docker ps -q) ]; then
  printf "\n${COLOR_BLUE}Stopping all docker running containers ${COLOR_WIPE} \n\n"
  docker stop $(docker ps -q)
fi


#####################################################################
# Mongo #
#####################################################################

if [ $SKIP_BUILD_IMAGES = true ]; then
  printf "\n${COLOR_BLUE}Skipping building mongo image ($MONGO_IMAGE_NAME) ${COLOR_WIPE} \n"
else
  printf "\n${COLOR_BLUE}Building mongo image ($MONGO_IMAGE_NAME) from $MONGO_DOCKERFILE_PATH/Dockerfile ${COLOR_WIPE} \n\n"
  docker build -t $MONGO_IMAGE_NAME $MONGO_DOCKERFILE_PATH
fi

printf "\n${COLOR_BLUE}Ensuring that mongo has a place to persist data ($MONGO_HOST_DATA_DIR) ${COLOR_WIPE} \n"
mkdir -p $MONGO_HOST_DATA_DIR

printf "\n${COLOR_BLUE}Starting mongo container ($MONGO_CONTAINER_NAME): ${COLOR_WIPE} \n"
printf "${COLOR_BLUE}...host port: $MONGO_HOST_PORT ${COLOR_WIPE} \n"
printf "${COLOR_BLUE}...container port: $MONGO_CONTAINER_PORT ${COLOR_WIPE} \n"
printf "${COLOR_BLUE}...host data directory: $MONGO_HOST_DATA_DIR ${COLOR_WIPE} \n"
printf "${COLOR_BLUE}...container data directory: $MONGO_CONTAINER_DATA_DIR ${COLOR_WIPE} \n\n"
docker run -d -p $MONGO_HOST_PORT:$MONGO_CONTAINER_PORT -v $MONGO_HOST_DATA_DIR:$MONGO_CONTAINER_DATA_DIR --name $MONGO_CONTAINER_NAME $MONGO_IMAGE_NAME


#####################################################################
# Node App #
#####################################################################

if [ $SKIP_BUILD_IMAGES = true ]; then
  printf "\n${COLOR_BLUE}Skipping building node app image ($NODE_IMAGE_NAME) ${COLOR_WIPE} \n"
else
  printf "\n${COLOR_BLUE}Building node app image ($NODE_IMAGE_NAME) from $NODE_DOCKERFILE_PATH/Dockerfile ${COLOR_WIPE} \n\n"
  docker build -t $NODE_IMAGE_NAME $NODE_DOCKERFILE_PATH
fi

printf "\n${COLOR_BLUE}Starting node app container ($NODE_CONTAINER_NAME): ${COLOR_WIPE} \n"
printf "${COLOR_BLUE}...host port: $NODE_HOST_PORT ${COLOR_WIPE} \n"
printf "${COLOR_BLUE}...container port: $NODE_CONTAINER_PORT ${COLOR_WIPE} \n"
printf "${COLOR_BLUE}...linked mongo container: $MONGO_CONTAINER_NAME ${COLOR_WIPE} \n\n"
docker run -d -t -p $NODE_HOST_PORT:$NODE_CONTAINER_PORT --link $MONGO_CONTAINER_NAME:mongo --name $NODE_CONTAINER_NAME $NODE_IMAGE_NAME


#####################################################################
# Varnish #
#####################################################################

if [ $SKIP_BUILD_IMAGES = true ]; then
  printf "\n${COLOR_BLUE}Skipping building varnish image ($VARNISH_IMAGE_NAME) ${COLOR_WIPE} \n"
else
  printf "\n${COLOR_BLUE}Building varnish image ($VARNISH_IMAGE_NAME) from $VARNISH_DOCKERFILE_PATH/Dockerfile ${COLOR_WIPE} \n\n"
  docker build -t $VARNISH_IMAGE_NAME $VARNISH_DOCKERFILE_PATH
fi

printf "\n${COLOR_BLUE}Starting varnish container ($VARNISH_CONTAINER_NAME): ${COLOR_WIPE} \n"
printf "${COLOR_BLUE}...host port: $VARNISH_HOST_PORT ${COLOR_WIPE} \n"
printf "${COLOR_BLUE}...container port: $VARNISH_CONTAINER_PORT ${COLOR_WIPE} \n"
docker run -d -t -p $VARNISH_HOST_PORT -e VARNISH_BACKEND_PORT=$VARNISH_CONTAINER_PORT --name $VARNISH_CONTAINER_NAME $VARNISH_IMAGE_NAME


#####################################################################

printf "\n${COLOR_GREEN}App is available at http://$(boot2docker ip 2>/dev/null):$NODE_HOST_PORT ${COLOR_WIPE} \n\n"

