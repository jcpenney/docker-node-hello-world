## Installing Dependencies

First, ensure that Docker is installed on your machine. As per [Docker.io's Mac OS X installation instructions](https://docs.docker.com/installation/mac/):

- Download [the latest release of the Docker for OS X Installer](https://github.com/boot2docker/osx-installer/releases).
- Run the installer, which will install VirtualBox and the Boot2Docker management tool.
- Initialize Boot2Docker by running `boot2docker init` from the command line


## Starting Docker

Start Docker and export the `DOCKER_HOST` environment variable with the following commands:

	boot2docker start
	export DOCKER_HOST=tcp://$(boot2docker ip 2>/dev/null):2375


## Starting Node Server

See [Node Server README](app/README.markdown)