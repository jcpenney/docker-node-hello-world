## Building the Mongo Image

To build the Mongo image, be sure that Docker has been started (see the "Starting Docker" section of the [project's documentation](../README.markdown)), then run the following command from the project's root:

	docker build -t jcpinnovation/hello-world-mongo ./mongo

As per [Docker's command line documentation](https://docs.docker.com/reference/commandline/cli/#build) the `-t` option specifies the tag name of the image. 
	

## Starting Mongo

To start Mongo, run the following command:

	docker run -d -p 27017:27017 -v mongo/data:/db --name mongo dockerfile/jcpinnovation/hello-world-mongo	

	
As per [Docker's command line documentation](https://docs.docker.com/reference/commandline/cli/#run):

- the `-d` option launches the container in detached mode (i.e. runs in the background)
- the `-p` option publishes the container's port to the host (i.e. the container's port `27017` will be accessible via port `27017` of the host IP printed by the `boot2docker ip` command)
- the `-v` option binds a volume from the host (`mongo/data/db`) to the container (`data/db`)
- the `--name` option assigns a name to the container
