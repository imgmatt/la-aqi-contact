# Static hosting on Railway via Caddy — tiny, fast, sets correct content types.
FROM caddy:2-alpine

COPY Caddyfile /etc/caddy/Caddyfile
COPY index.html /srv/index.html

# Railway provides $PORT at runtime; Caddyfile reads it. EXPOSE is informational.
EXPOSE 80

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
