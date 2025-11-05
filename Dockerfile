FROM bellsoft/liberica-runtime-container:jdk-21-musl as native_builder

ENV PORT=3000

WORKDIR /build

RUN apk add --no-cache curl
RUN curl -L -# -O https://github.com/structurizr/lite/releases/download/v2025.11.01/structurizr-lite.war

FROM bellsoft/liberica-runtime-container:jdk-21-musl

RUN apk add --no-cache graphviz

COPY --from=native_builder /build/structurizr-lite.war /usr/local/structurizr-lite.war

EXPOSE ${PORT}

ENTRYPOINT ["java","-Dserver.port=${PORT}","-jar","/usr/local/structurizr-lite.war"]