# DOCKER-VERSION 1.1.1

# Set the base/parent image
FROM dockerfile/mongodb

# Set maintainer
MAINTAINER JCP Innovation <jcp.innovation.team@gmail.com>

# Override command, setting smallfiles argument (https://github.com/dockerfile/mongodb/issues/9)
CMD ["mongod", "--smallfiles"]