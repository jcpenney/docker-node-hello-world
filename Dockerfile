# DOCKER-VERSION 1.1.1

# Set the base/parent image
FROM dockerfile/nodejs

# Set maintainer
MAINTAINER JCP Innovation <jcp.innovation.team@gmail.com>

# Bundle app source
ADD . /app

# Install app dependencies
RUN cd /app; npm install; npm install -g forever

# Expose port for Node app
EXPOSE  8080

# Start server
CMD forever /app/src/server.js
