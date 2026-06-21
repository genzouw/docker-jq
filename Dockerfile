FROM alpine:3.24.1

LABEL maintainer "genzouw <genzouw@gmail.com>"

RUN apk add --no-cache \
  jq \
  ;

# 非 root 実行（Trivy DS-0002 対応）。jq は stdin/stdout のみ使用するため nobody で十分
USER nobody

ENTRYPOINT ["/usr/bin/jq"]
