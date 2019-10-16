FROM alpine:3.10.2

RUN apk add --no-cache \
  jq \
  ;

ENTRYPOINT ["/usr/bin/jq"]

CMD [""]
