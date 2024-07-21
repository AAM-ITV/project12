FROM tomcat:9-jdk11-openjdk-slim

RUN apt-get update && apt-get install -y git maven

# Клонируем репозиторий
RUN git clone https://github.com/AAM-ITV/project12.git /usr/local/tomcat/webapps/hello

# Проверяем содержимое /usr/local/tomcat/webapps/hello
RUN ls -la /usr/local/tomcat/webapps/hello

# Устанавливаем рабочую директорию
WORKDIR /usr/local/tomcat/webapps/hello

# Собираем проект Maven
RUN mvn package

# Проверяем содержимое target после сборки
RUN ls -la target

# Перемещаем .war файл в директорию веб-приложений Tomcat
RUN mv target/*.war /usr/local/tomcat/webapps/hello.war

# Проверяем содержимое /usr/local/tomcat/webapps после перемещения
RUN ls -la /usr/local/tomcat/webapps

# Открываем порт 8080
EXPOSE 8080
