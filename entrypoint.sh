#!/bin/sh

if [ -z "${ID}" ]; then
    ID="82516518-2311-8160-0000-000000000000"
fi

if [ -z "${SERVER}" ]; then
    SERVER="Hyperwarp"
fi

if [ -z "${DESCRIPTION}" ]; then
    DESCRIPTION="Default Hyperwarp server"
fi

mkdir -p /etc/supervisor.d

cat << EOF > /opt/v2ray.json
{
    "inbounds": [{
        "port": 50000,
        "protocol": "vmess",
        "settings": {
            "clients": [{
                "id": "${ID}",
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
    header * Server "${SERVER}"
    header * Description "${DESCRIPTION}"
    reverse_proxy / localhost:50000
}
EOF

# V2Ray
cat << EOF > /etc/supervisor.d/v2ray.ini
[program:v2ray]
command=/opt/v2ray -config /opt/v2ray.json
autostart=true
startsecs=3
autorestart=true
startretries=3
EOF

# Caddy
cat << "EOF" > /etc/supervisor.d/caddy.ini
[program:caddy]
command=/opt/caddy run --config /opt/Caddyfile
autostart=true
startsecs=3
autorestart=true
startretries=3
EOF

supervisord -n
