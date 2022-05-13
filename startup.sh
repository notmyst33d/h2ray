if [ -z "${UUID}" ]; then
    UUID="4431842e-e7e1-4006-b9fe-0527afc738c6"
fi

if [ -z "${SPOOF_HOST}" ]; then
    SPOOF_HOST="https://www.cloudflare.com"
fi

cat << EOF > /opt/config.json
{
    "inbounds": [{
        "port": 50000,
        "protocol": "vmess",
        "settings": {
            "clients": [{
                "id": "${UUID}",
                "alterId": 64
            }]
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {
                "path": "/"
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF

cat << EOF > /opt/Caddyfile
http://:${PORT} {
    route /ping {
        header * Access-Control-Allow-Origin "*"
        header * Access-Control-Allow-Methods "*"

        respond "Pong"
    }

    route /* {
        @websocket {
            header_regexp Connection Upgrade
            header Upgrade websocket
        }

        reverse_proxy @websocket localhost:50000

        reverse_proxy ${SPOOF_HOST} {
            header_up Host {http.reverse_proxy.upstream.hostport}
        }
    }
}
EOF

/opt/xray -config /opt/config.json &
/opt/caddy run -config /opt/Caddyfile
