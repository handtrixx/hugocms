# Use an official Node.js runtime as a base image
FROM golang:bookworm

#RUN apt-get update && apt-get install -y npm git curl net-tools procps &&  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get update && \
    apt-get install -y git curl net-tools procps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#install hugo extended
RUN CGO_ENABLED=1 go install -tags extended github.com/gohugoio/hugo@latest
#adduser hugo
RUN useradd -m -s /bin/bash hugo

# Prepare and set the working directory inside the container
RUN mkdir -p /var/www/public
RUN chown -R hugo:hugo /var/www

COPY --chown=root:root entrypoint.sh /entrypoint.sh
#COPY --chown=root:root cron.sh /cron.sh
RUN chmod +x /entrypoint.sh

# Expose the port your app runs on
EXPOSE 1313
# change user to hugo
USER hugo

WORKDIR /var
RUN hugo new site www
WORKDIR /var/www

# Define the startup command
CMD ["sh","/entrypoint.sh"]

# Add healthcheck
#HEALTHCHECK --interval=60s --timeout=50s --start-period=20s --start-interval=5s \
#  CMD /cron.sh || exit 1



