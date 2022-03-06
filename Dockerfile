FROM alpine:edge

RUN apk update
RUN apk upgrade

ADD entrypoint.sh /opt/entrypoint.sh
ADD bin/caddy /opt/caddy
ADD bin/v2ray /opt/v2ray

RUN chmod +x /opt/entrypoint.sh && chmod +x /opt/caddy && chmod +x /opt/v2ray

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]
