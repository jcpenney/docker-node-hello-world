## Installing Dependencies

First, ensure that Docker is installed on your machine. As per [Docker.io's Mac OS X installation instructions](https://docs.docker.com/installation/mac/):

- Download [the latest release of the Docker for OS X Installer](https://github.com/boot2docker/osx-installer/releases).
- Run the installer, which will install VirtualBox and the Boot2Docker management tool.
- Initialize and start Boot2Docker by running the following from the command line:
	- `boot2docker init`
	- `boot2docker start`
	- `export DOCKER_HOST=tcp://$(boot2docker ip 2>/dev/null):2375`



## Building the Node Server Image

To build the Node server image, run the following command from the project's root:

	docker build -t jcpinnovation/node-hello-world .

As per [Docker's command line documentation](https://docs.docker.com/reference/commandline/cli/#build) the `-t` option specifies the tag name of the image. 
	

## Starting the Node Server

To start the Node server, run the following command from the project's root:

	docker run -d -t -p 49160:8080 jcpinnovation/node-hello-world
	
As per [Docker's command line documentation](https://docs.docker.com/reference/commandline/cli/#run):

- the `-d` option launches the container in detached mode (i.e. runs in the background)
- the `-t` option allocates a pseudo-tty
- the `-p` option publishes the container's port to the host (i.e. the container's port `8080` will be accessible via the port `49160` of the host IP specified by `boot2docker ip`)

