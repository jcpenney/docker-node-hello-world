## Installing Dependencies

First, ensure that Docker is installed on your machine. As per [Docker.io's Mac OS X installation instructions](https://docs.docker.com/installation/mac/):

- Download [the latest release of the Docker for OS X Installer](https://github.com/boot2docker/osx-installer/releases).
- Run the installer, which will install VirtualBox and the Boot2Docker management tool.
- Initialize Boot2Docker, then start Docker manually and export the `DOCKER_HOST` environment variable with the following commands:
	- `boot2docker init`
	- `boot2docker start`
	- `export DOCKER_HOST=tcp://$(boot2docker ip 2>/dev/null):2375`


## Starting the App

To start the app, run the following command from the project's root:

	. start.sh

The script will start Docker using [boot2docker](https://github.com/boot2docker/boot2docker), stop any already-running Docker containers, start Mongo ([More Info](mongo/README.markdown)), then finally start the Node app ([More info](app/README.markdown)).