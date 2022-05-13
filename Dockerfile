FROM alpine:edge

WORKDIR /opt

# Update the system and get neccesary packages
RUN apk update
RUN apk upgrade
RUN apk add wget unzip

# Download Xray and Caddy
RUN wget https://github.com/caddyserver/caddy/releases/download/v2.5.1/caddy_2.5.1_linux_amd64.tar.gz
RUN wget https://github.com/XTLS/Xray-core/releases/download/v1.5.5/Xray-linux-64.zip

# Unpack Xray and Caddy
RUN tar -xzvf caddy_2.5.1_linux_amd64.tar.gz
RUN unzip -o Xray-linux-64.zip

# Remove downloaded files to save space
RUN rm caddy_2.5.1_linux_amd64.tar.gz Xray-linux-64.zip

# Copy startup.sh
COPY startup.sh /opt

# Make sure everything is executable
RUN chmod +x /opt/startup.sh && chmod +x /opt/caddy && chmod +x /opt/xray

ENTRYPOINT ["sh", "-c", "/opt/startup.sh"]

