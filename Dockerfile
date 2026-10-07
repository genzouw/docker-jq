FROM alpine:3.24.2

LABEL maintainer "genzouw <genzouw@gmail.com>"

# Snyk SNYK-ALPINE324-ZLIB-20541555（zlib の Out-of-bounds Write）対応。
# base image に含まれる zlib 1.3.2-r0 を修正版 1.3.2-r1 以降へ上げる
RUN apk add --no-cache \
  jq \
  && apk upgrade --no-cache zlib \
  ;

# 非 root 実行（Trivy DS-0002 対応）。jq は stdin/stdout のみ使用するため nobody で十分
USER nobody

ENTRYPOINT ["/usr/bin/jq"]
