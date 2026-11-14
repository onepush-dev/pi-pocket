# Pi Pocket on Railway: upstream TannerMidd/pi-pocket (MIT) built from its own docker/Dockerfile at the pinned
# release v0.29.0-beta.8 (cbb1eba6e99d0dbf2d7a16c68dabccfc05ca7a37), app unmodified. This layer only:
#  - folds Pi Pocket's five folders into ONE Railway volume at /data (Pi's ~/.pi -> /data/pi, /workspace -> /data/workspace;
#    /data/extensions and /data/themes are already inside /data),
#  - pre-seeds the owner sign-in token from PI_POCKET_OWNER_TOKEN on first boot (upstream's own config.json format),
#  - listens on 8080. Defaults are baked as ENV because Railway templates drop plain variable values.
ARG BASE=ghcr.io/onepush-dev/pi-pocket-base:0.29.0-beta.8
FROM ${BASE}
LABEL org.opencontainers.image.source="https://github.com/onepush-dev/pi-pocket"
USER root
RUN rm -rf /home/node/.pi /workspace \
    && ln -s /data/pi /home/node/.pi \
    && ln -s /data/workspace /workspace
COPY railway/start.sh /opt/railway/start.sh
RUN chmod 755 /opt/railway/start.sh
ENV HOME=/home/node \
    PI_POCKET_DIR=/data \
    PI_POCKET_ACCESS=lan \
    PI_POCKET_PORT=8080 \
    PI_POCKET_KEEPALIVE_SECONDS=125 \
    PI_POCKET_BROWSER=/usr/bin/chromium \
    PI_POCKET_BROWSER_ARGS="--no-sandbox --disable-dev-shm-usage"
WORKDIR /app
EXPOSE 8080
HEALTHCHECK NONE
ENTRYPOINT ["/usr/bin/tini", "--", "/opt/railway/start.sh"]
CMD []
