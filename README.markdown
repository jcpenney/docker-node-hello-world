# Building the Node Server Image

To build the Node server image, run the following command from the project's root:

	docker build -t jcpinnovation/node-hello-world --rm=true .
	
# Starting the Node Server

To start the Node server (on port `49160`), run the following command from the project's root:

	docker run -p 49160:8080 -d jcpinnovation/node-hello-world