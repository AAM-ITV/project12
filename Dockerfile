# Используем базовый образ Tomcat
FROM tomcat:9-jdk11-openjdk-slim

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y git maven

# Клонируем репозиторий в рабочую директорию
RUN git clone https://github.com/AAM-ITV/project12.git /usr/local/tomcat/webapps/hello

# Устанавливаем рабочую директорию
WORKDIR /usr/local/tomcat/webapps/hello

# Собираем проект Maven
RUN mvn package

# Проверяем содержимое каталога target
RUN ls -la target

# Переименовываем .war файл (если необходимо) и копируем в директорию Tomcat
RUN mv target/*.war /usr/local/tomcat/webapps/hello-app.war


# Открываем порт 8080
EXPOSE 8080
