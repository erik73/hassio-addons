ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_ARCH

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
RUN apk add --no-cache \
    openjdk11 \
    maven \
    xmlstarlet \
    mariadb-client \
    && mkdir -p /usr/src \
    && curl -L -s -o steve.tar.gz "https://github.com/RWTH-i5-IDSG/steve/archive/steve-3.4.4.tar.gz"; \
        mkdir /usr/src/steve; \
        tar -xf steve.tar.gz -C /usr/src/steve --strip-components=1; \
        rm steve.tar.gz;
# Copy data for add-on
COPY rootfs /

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Steve" \
    io.hass.description="OCPP server for EV charging stations" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Erik Hilton <erikhilton73@gmail.com>" \
    org.opencontainers.image.title="SteVe" \
    org.opencontainers.image.description="OCPP server for EV charging stations" \
    org.opencontainers.image.vendor="Erik73 Hassio-Addons" \
    org.opencontainers.image.authors="Erik Hilton <erikhilton73@gmail.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
