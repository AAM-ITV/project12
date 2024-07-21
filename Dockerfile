# Используем базовый образ Tomcat
FROM tomcat:9-jdk11-openjdk-slim

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y git maven

# Клонируем репозиторий и копируем его содержимое в рабочую директорию
RUN git clone https://github.com/AAM-ITV/project12.git /usr/local/tomcat/webapps/hello

WORKDIR /usr/local/tomcat/webapps/hello


RUN mvn package


RUN cp target/*.war /usr/local/tomcat/webapps/


# Открываем порт 8080 для доступа к приложению
EXPOSE 8080

