FROM homeassistant/home-assistant:0.85.1
LABEL maintainer="Peter Foreman <peter@frmn.nl>"

# Install socat
RUN apt-get update && \
    apt-get -y install socat mosquitto-clients mysql-client && \
    apt-get clean
RUN mkdir /runwatch

# Run
COPY runwatch/* /runwatch/
CMD [ "bash","/runwatch/run.sh" ]
