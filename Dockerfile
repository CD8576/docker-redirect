FROM caddy:2-alpine
ENV PORT=8000
ENV TARGET="wss://neo-device-revision-mount.trycloudflare.com"
RUN printf '%s\n' \
 '#!/bin/sh' \
 'T="$TARGET"' \
 'T="${T#wss://}"; T="${T#ws://}"; T="${T#https://}"; T="${T%/}"' \
 '[ -z "$T" ] && { echo "Set the TARGET env var to your wss:// link"; exit 1; }' \
 'printf ":%s {\n\treverse_proxy https://%s {\n\t\theader_up Host %s\n\t}\n}\n" "${PORT:-8000}" "$T" "$T" > /tmp/Caddyfile' \
 'exec caddy run --config /tmp/Caddyfile --adapter caddyfile' \
 > /start.sh && chmod +x /start.sh
EXPOSE 8000
ENTRYPOINT ["/start.sh"]
