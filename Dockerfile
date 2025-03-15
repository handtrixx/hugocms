# Use an official Node.js runtime as a base image
FROM golang:bookworm

RUN apt-get update && apt-get install -y git curl net-tools procps &&  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#install hugo extended
RUN CGO_ENABLED=1 go install -tags extended github.com/gohugoio/hugo@latest
#adduser hugo
RUN useradd -m -s /bin/bash hugo
# Prepare and set the working directory inside the container
RUN mkdir -p /var/www
RUN chown -R hugo:hugo /var/www
WORKDIR /var/www

COPY --chown=hugo:hugo entrypoint.sh /entrypoint.sh

# Expose the port your app runs on
EXPOSE 1313
# change user to hugoq
USER hugo

RUN hugo new site site
WORKDIR /var/www/site

# Define the startup command
CMD ["sh","/entrypoint.sh"]


