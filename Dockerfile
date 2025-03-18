# Use an official Node.js runtime as a base image
FROM golang:bookworm

#RUN apt-get update && apt-get install -y npm git curl net-tools procps &&  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs git curl net-tools procps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#install hugo extended
RUN CGO_ENABLED=1 go install -tags extended github.com/gohugoio/hugo@latest
#adduser hugo
RUN useradd -m -s /bin/bash hugo

# Prepare and set the working directory inside the container
RUN mkdir -p /var/www/site/public
RUN chown -R hugo:hugo /var/www
WORKDIR /var/www

COPY --chown=root:root entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh


# Expose the port your app runs on
EXPOSE 1313
# change user to hugo
USER hugo

RUN hugo new site site
WORKDIR /var/www/site
COPY --chown=hugo:hugo postcss.config.js /var/www/site/postcss.config.js
COPY --chown=hugo:hugo hugo.toml /var/www/site/hugo.toml
RUN npm init -y
RUN npm install postcss postcss-cli @fullhuman/postcss-purgecss --save -y

# Define the startup command
CMD ["sh","/entrypoint.sh"]



