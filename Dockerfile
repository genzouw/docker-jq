FROM alpine:3.11.3

LABEL maintainer "genzouw <genzouw@gmail.com>"

RUN apk add --no-cache \
  jq \
  ;

ENTRYPOINT ["/usr/bin/jq"]
