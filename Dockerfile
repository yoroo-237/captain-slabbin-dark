FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends tor nginx gettext-base ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

COPY torrc /etc/tor/torrc
COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY start.sh /start.sh
RUN sed -i 's/\r$//' /start.sh && chmod +x /start.sh

CMD ["/start.sh"]
