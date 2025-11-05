FROM bellsoft/liberica-runtime-container:jdk-21-musl as native_builder

ENV PORT=3000

WORKDIR /build

RUN apk add --no-cache curl && \
    apk add --no-cache tomcat-native-dev apr openssl
RUN curl -L -# -O https://github.com/structurizr/lite/releases/download/v2025.11.01/structurizr-lite.war

FROM bellsoft/liberica-runtime-container:jdk-21-musl

RUN apk add --no-cache graphviz

COPY --from=native_builder /build/structurizr-lite.war /usr/local/structurizr-lite.war

COPY --from=native_builder /usr/lib/libtcnative-*.so* /usr/lib/
COPY --from=native_builder /usr/lib/libapr-*.so* /usr/lib/

COPY --from=native_builder /usr/lib/libssl.so.* /usr/lib/
COPY --from=native_builder /usr/lib/libcrypto.so.* /usr/lib/

EXPOSE ${PORT}

ENTRYPOINT ["java","-Djava.library.path=/usr/lib","-Dserver.port=${PORT}","-jar","/usr/local/structurizr-lite.war"]