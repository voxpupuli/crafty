FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

# Install OpenVox agent and Apache once at image build time.
RUN apt-get update \
  && apt-get install -y --no-install-recommends curl ca-certificates \
  && curl -LR https://apt.voxpupuli.org/openvox8-release-ubuntu24.04.deb -o /tmp/openvox8-release-ubuntu24.04.deb \
  && dpkg -i /tmp/openvox8-release-ubuntu24.04.deb \
  && apt-get update \
  && apt-get install -y --no-install-recommends openvox-agent apache2 \
  && rm -rf /var/lib/apt/lists/* /tmp/openvox8-release-ubuntu24.04.deb

COPY ./scripts/webserver-entrypoint.sh /usr/local/bin/webserver-entrypoint.sh
RUN chmod +x /usr/local/bin/webserver-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/webserver-entrypoint.sh"]
