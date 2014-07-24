# DOCKER-VERSION 1.1.1

# Set the base/parent image
FROM centos:centos6

# Set maintainer
MAINTAINER JCP Innovation <jcp.innovation.team@gmail.com>

# Create worker user and ensure that his .bash_profile exists
RUN useradd -m worker
RUN su - worker -c "touch ~/.bash_profile"

# Download and install updates for all currently installed packages
RUN yum -y update

# Download and install man pages
RUN yum install -y man

# Enable EPEL
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

# Download and install all packages from the "Development Tools" group
RUN yum -y groupinstall "Development Tools"

# Install Node
RUN yum install -y nodejs

# Download and activate NVM
RUN su - worker -c "curl https://raw.githubusercontent.com/creationix/nvm/v0.12.0/install.sh | bash"
RUN su - worker -c ". ~/.bash_profile"

# Install node and set default version
RUN su - worker -c "nvm install 0.11.13"
RUN su - worker -c "nvm alias default 0.11.13"
RUN su - worker -c "nvm use default"

# Bundle app source
ADD . /app

# Install app dependencies
RUN su - worker -c "cd /app; npm install; npm install -g forever"

# Expose port for Node app
EXPOSE  8080

# Define Command to run app
# CMD su - worker
# CMD ["su - worker", "node /app/src/server.js"]
