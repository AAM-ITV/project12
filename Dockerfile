# Используем базовый образ Tomcat
FROM tomcat:9-jdk11-openjdk-slim

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y git maven

# Клонируем репозиторий и копируем его содержимое в рабочую директорию
RUN git clone https://github.com/AAM-ITV/project12.git /app

# Устанавливаем рабочую директорию
WORKDIR /app

# Собираем проект Maven
RUN mvn package

# Переименовываем .war файл
RUN mv target/*.war /app/myapp.war

# Копируем переименованный .war файл в директорию веб-приложений Tomcat
RUN cp /app/myapp.war /usr/local/tomcat/webapps

# Открываем порт 8080 для доступа к приложению
EXPOSE 8080

