FROM alpine:3.10.2

RUN apk add \
  --no-cache \
  --virtual=build-deps curl \
  && curl -sS -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 >/usr/local/bin/jq \
  && chmod +x /usr/local/bin/jq \
  && apk del curl \
  && apk del build-deps

ENTRYPOINT ["/usr/local/bin/jq", "-C"]

CMD [""]
