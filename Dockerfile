FROM alpine:latest

RUN apk add --no-cache git openssh-client openssl nodejs npm

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]