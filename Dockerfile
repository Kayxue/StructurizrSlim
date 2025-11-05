FROM bellsoft/liberica-runtime-container:jdk-21-musl AS native_builder

WORKDIR /build

RUN apk add --no-cache curl tar

RUN curl -L -# -O https://github.com/structurizr/lite/releases/download/v2025.11.01/structurizr-lite.war

FROM bellsoft/liberica-runtime-container:jdk-21-musl

ENV PORT=3000

RUN apk add --no-cache graphviz

ENV STRUCTURIZR_DATA_DIRECTORY=/usr/local/structurizr

COPY --from=native_builder /build/structurizr-lite.war /usr/local/structurizr-lite.war

EXPOSE ${PORT}

CMD ["java", "-Dserver.port=${PORT}", "--enable-native-access=ALL-UNNAMED", "-jar", "/usr/local/structurizr-lite.war"]