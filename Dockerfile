FROM alpine:edge

RUN apk update
RUN apk upgrade
RUN apk add supervisor

ADD entrypoint.sh /opt/entrypoint.sh
ADD caddy /opt/caddy
ADD v2ray /opt/v2ray

RUN chmod +x /opt/entrypoint.sh && chmod +x /opt/caddy && chmod +x /opt/v2ray

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]
