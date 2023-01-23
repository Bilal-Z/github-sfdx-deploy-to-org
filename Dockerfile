FROM alpine:latest

RUN apk add --no-cache git openssh-client openssl nodejs npm

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]