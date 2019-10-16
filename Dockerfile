FROM alpine:3.10.2

LABEL maintainer "genzouw <genzouw@gmail.com>"

RUN apk add --no-cache \
  jq \
  ;

ENTRYPOINT ["/usr/bin/jq"]

CMD [""]
