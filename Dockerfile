
FROM maven:3.6.3-openjdk-11 as builder

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn package

FROM tomcat:9-jdk11-openjdk

COPY --from=builder /app/target/App42PaaS-Java-MySQL-Sample.war /usr/local/tomcat/webapps/

EXPOSE 8080
