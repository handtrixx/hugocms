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
RUN mkdir -p /var/www/prd/public
RUN mkdir -p /var/www/qas/public
RUN mkdir -p /var/www/dev/public
RUN chown -R hugo:hugo /var/www

COPY --chown=root:root entrypoint.sh /entrypoint.sh
COPY --chown=root:root cron.sh /cron.sh
RUN chmod +x /entrypoint.sh /cron.sh

# Expose the port your app runs on
EXPOSE 1313
EXPOSE 1314
EXPOSE 1315
# change user to hugo
USER hugo

WORKDIR /var/www
RUN hugo new site prd
RUN hugo new site qas
RUN hugo new site dev
COPY --chown=hugo:hugo postcss.config.js /var/www/prd/postcss.config.js
COPY --chown=hugo:hugo postcss.config.js /var/www/qas/postcss.config.js
COPY --chown=hugo:hugo postcss.config.js /var/www/dev/postcss.config.js
COPY --chown=hugo:hugo hugo.toml /var/www/prd/hugo.toml
COPY --chown=hugo:hugo hugo.toml /var/www/qas/hugo.toml
COPY --chown=hugo:hugo hugo.toml /var/www/dev/hugo.toml
WORKDIR /var/www/prd
RUN npm init -y
RUN npm install postcss postcss-cli @fullhuman/postcss-purgecss --save -y
WORKDIR /var/www/qas
RUN npm init -y
RUN npm install postcss postcss-cli @fullhuman/postcss-purgecss --save -y
WORKDIR /var/www/dev
RUN npm init -y
RUN npm install postcss postcss-cli @fullhuman/postcss-purgecss --save -y
WORKDIR /var/www

# Define the startup command
CMD ["sh","/entrypoint.sh"]

# Add healthcheck
HEALTHCHECK --interval=60s --timeout=50s --start-period=20s --start-interval=5s \
  CMD /cron.sh || exit 1



