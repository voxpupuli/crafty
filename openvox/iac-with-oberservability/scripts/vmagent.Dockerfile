FROM alpine:latest

# Install runtime/build dependencies and OpenVox client once at image build time.
RUN apk add --no-cache \
    curl \
    tar \
    ruby \
    ruby-dev \
    ruby-racc \
    ruby-syslog \
    shadow \
    util-linux \
    build-base \
  && gem install --no-document openvox

COPY ./scripts/vmagent-entrypoint.sh /usr/local/bin/vmagent-entrypoint.sh
RUN chmod +x /usr/local/bin/vmagent-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/vmagent-entrypoint.sh"]
