# Build the Servlet/JSP application without Maven or Gradle.
FROM tomcat:10.1-jdk17-temurin AS build

WORKDIR /app
COPY lib/ lib/
COPY src/ src/

RUN mkdir -p build/ROOT/WEB-INF/classes build/ROOT/WEB-INF/lib \
    && cp -R src/main/webapp/. build/ROOT/ \
    && cp lib/mysql-connector-j-26.7.0.jar build/ROOT/WEB-INF/lib/ \
    && find src/main/java -name "*.java" -print0 | xargs -0 javac -cp "lib/*" -d build/ROOT/WEB-INF/classes

# Tomcat serves the app at /, so the Railway domain opens Quantix directly.
FROM tomcat:10.1-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/build/ROOT /usr/local/tomcat/webapps/ROOT
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
