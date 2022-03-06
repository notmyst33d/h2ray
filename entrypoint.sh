if [ -z "${V2RAY_ID}" ]; then
    V2RAY_ID="4431842e-e7e1-4006-b9fe-0527afc738c6"
fi

cat << EOF > /opt/v2ray.json
{
    "inbounds": [{
        "port": 50000,
        "protocol": "vmess",
        "settings": {
            "clients": [{
                "id": "${V2RAY_ID}",
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
    header * Access-Control-Allow-Origin "*"
    header * Access-Control-Allow-Methods "*"
    reverse_proxy / localhost:50000
}
EOF

/opt/v2ray -config /opt/v2ray.json &
/opt/caddy run -config /opt/Caddyfile
