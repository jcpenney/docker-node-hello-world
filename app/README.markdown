## Building the Node Server Image

To build the Node server image, be sure that Docker has been started (see the "Starting Docker" section of the [project's documentation](../README.markdown)), then run the following command from the project's root:

	docker build -t jcpinnovation/hello-world-node ./app

As per [Docker's command line documentation](https://docs.docker.com/reference/commandline/cli/#build) the `-t` option specifies the tag name of the image. 
	

## Starting the Node Server

To start the Node server, run the following command:

	docker run -d -t -p 49160:8080 --name node --link mongo:mongo jcpinnovation/hello-world-node
	
As per [Docker's command line documentation](https://docs.docker.com/reference/commandline/cli/#run):

- the `-d` option launches the container in detached mode (i.e. runs in the background)
- the `-t` option allocates a pseudo-tty
- the `-p` option publishes the container's port to the host (i.e. the container's port `8080` will be accessible via port `49160` of the host IP printed by the `boot2docker ip` command)
- the `--link` option link to another container (name:alias)
- the `--name` option assigns a name to the container


