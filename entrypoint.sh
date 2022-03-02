#!/bin/sh

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
    header * Server "hyperwarp"
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
