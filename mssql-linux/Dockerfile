FROM mcr.microsoft.com/mssql/server:2019-latest

# Switch to root user for access to apt-get install and other administrative tasks
USER root
ARG DEBIAN_FRONTEND=noninteractive

# Install os packages
RUN apt-get -y update  && \
        apt-get install -y curl vim

# Config directory
RUN mkdir -p /usr/config
WORKDIR /usr/config

# Bundle config source
COPY ./config/ /usr/config
COPY ./data/ /usr/config

# Script permissions to be executable
RUN chmod +x /usr/config/entrypoint.sh
RUN chmod +x /usr/config/setup.sh

ENTRYPOINT ["./entrypoint.sh"]

# Tail the setup logs to trap the process
CMD ["tail -f /dev/null"]