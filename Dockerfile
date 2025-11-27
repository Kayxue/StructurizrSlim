FROM alpine:latest AS downloader

RUN apk add --no-cache ca-certificates wget

RUN wget -O /structurizr-lite.war https://github.com/structurizr/lite/releases/download/v2025.11.08/structurizr-lite.war

FROM bellsoft/liberica-runtime-container:jre-21-glibc

ENV PORT=3000

RUN apk add --no-cache graphviz

ENV STRUCTURIZR_DATA_DIRECTORY=/usr/local/structurizr

COPY --from=downloader /build/structurizr-lite.war /usr/local/structurizr-lite.war

EXPOSE ${PORT}

CMD ["java", "-Dserver.port=${PORT}", "--enable-native-access=ALL-UNNAMED", "-jar", "/usr/local/structurizr-lite.war"]