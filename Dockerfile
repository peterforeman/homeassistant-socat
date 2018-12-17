FROM "homeassistant/home-assistant:latest"
LABEL maintainer="Peter Foreman <peter@frmn.nl>"

# Install socat
RUN apt-get update && apt-get -y install socat && apt-get clean
RUN mkdir /runwatch

# Run
COPY runwatch/run.sh /runwatch/run.sh
# Monitor socat
COPY runwatch/100.socat-zwave.enabled.sh /runwatch/100.socat-zwave.enabled.sh
# Monitor HomeAssistant
COPY runwatch/200.home-assistant.enabled.sh /runwatch/200.home-assistant.enabled.sh

CMD [ "bash","/runwatch/run.sh" ]
