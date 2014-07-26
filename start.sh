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

PROJECT_ROOT=$(cd `dirname ${0}`; pwd)

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

SKIP_BUILD_IMAGES=false

while getopts 'abf:v' flag; do
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

printf "\n${COLOR_BLUE}Stopping all docker containers ${COLOR_WIPE} \n\n"
docker stop $(docker ps -a -q)


#####################################################################
# Mongo #
#####################################################################

if [ $SKIP_BUILD_IMAGES == false ] ; then
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
echo docker run -d -p $MONGO_HOST_PORT:$MONGO_CONTAINER_PORT -v $MONGO_HOST_DATA_DIR:$MONGO_CONTAINER_DATA_DIR --name $MONGO_CONTAINER_NAME $MONGO_IMAGE_NAME
docker run -d -p $MONGO_HOST_PORT:$MONGO_CONTAINER_PORT -v $MONGO_HOST_DATA_DIR:$MONGO_CONTAINER_DATA_DIR --name $MONGO_CONTAINER_NAME $MONGO_IMAGE_NAME


# #####################################################################
# # Node App #
# #####################################################################

if [ $SKIP_BUILD_IMAGES == false ] ; then
  printf "\n${COLOR_BLUE}Building node app image ($NODE_IMAGE_NAME) from $NODE_DOCKERFILE_PATH/Dockerfile ${COLOR_WIPE} \n\n"
  docker build -t $NODE_IMAGE_NAME $NODE_DOCKERFILE_PATH
fi

printf "\n${COLOR_BLUE}Starting node app container ($NODE_CONTAINER_NAME): ${COLOR_WIPE} \n"
printf "${COLOR_BLUE}...host port: $NODE_HOST_PORT ${COLOR_WIPE} \n"
printf "${COLOR_BLUE}...container port: $NODE_CONTAINER_PORT ${COLOR_WIPE} \n"
printf "${COLOR_BLUE}...linked mongo container: $MONGO_CONTAINER_NAME ${COLOR_WIPE} \n\n"
docker run -d -t -p $NODE_HOST_PORT:$NODE_CONTAINER_PORT --link $MONGO_CONTAINER_NAME:mongo --name $NODE_CONTAINER_NAME $NODE_IMAGE_NAME

