FROM docker/compose:1.29.2

EXPOSE 1080

RUN apk --update add bash coreutils ca-certificates \
 && rm -rf /var/cache/apk/*

HEALTHCHECK --retries=10 CMD [ "/app", "-url", "http://localhost:1080/health" ]
ENTRYPOINT [ "/app" ]

ARG APP_VERSION
ENV VERSION=${APP_VERSION}

COPY bin/deploy /app
