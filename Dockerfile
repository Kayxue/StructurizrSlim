FROM bellsoft/liberica-runtime-container:jdk-21-musl AS native_builder

WORKDIR /build

RUN apk add --no-cache curl tar

RUN curl -L -# -O https://github.com/structurizr/onpremises/releases/download/v2025.11.01/structurizr-onpremises.war

RUN curl -L -# -O https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.48/bin/apache-tomcat-10.1.48.tar.gz \
    && tar -xzf apache-tomcat-10.1.48.tar.gz \
    && mv apache-tomcat-10.1.48 /usr/local/tomcat

FROM bellsoft/liberica-runtime-container:jdk-21-musl

ENV PORT=3000

RUN apk add --no-cache graphviz

COPY --from=native_builder /usr/local/tomcat /usr/local/tomcat

WORKDIR /usr/local/tomcat

RUN sed -i 's/port="8080"/port="${http.port}" maxPostSize="10485760"/' conf/server.xml \
    && echo 'export CATALINA_OPTS="-Xms512M -Xmx512M -Dhttp.port=$PORT"' > bin/setenv.sh \
    && chmod +x bin/*.sh

RUN rm -rf /usr/local/tomcat/webapps/ROOT*
COPY --from=native_builder /build/structurizr-onpremises.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE ${PORT}

CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]