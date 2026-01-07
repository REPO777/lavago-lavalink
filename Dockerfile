FROM eclipse-temurin:21-jre-alpine

LABEL maintainer="Houkago Bot"
LABEL description="LAVAGO - Premium Lavalink Server"
LABEL version="2.0.0"

WORKDIR /opt/lavalink

RUN apk add --no-cache curl bash

RUN mkdir -p /opt/lavalink/plugins /opt/lavalink/logs

ENV LAVALINK_VERSION=4.1.2
RUN curl -L -o Lavalink.jar "https://github.com/lavalink-devs/Lavalink/releases/download/${LAVALINK_VERSION}/Lavalink.jar"

COPY application.yml .

EXPOSE 2333

ENV _JAVA_OPTIONS="-Xmx512M -Xms256M -XX:+UseG1GC -XX:MaxGCPauseMillis=100"

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:${PORT:-2333}/version || exit 1

CMD ["sh", "-c", "java -Dserver.port=${PORT:-2333} -jar Lavalink.jar"]
