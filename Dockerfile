# Используем Tomcat образ
FROM tomcat:9-jdk11-openjdk-slim

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y git maven

# Клонируем репозиторий
RUN git clone https://github.com/shephertz/App42PaaS-Java-MySQL-Sample.git /usr/local/tomcat/webapps/hello

# Переходим в директорию проекта
WORKDIR /usr/local/tomcat/webapps/hello

# Собираем проект с помощью Maven
RUN mvn clean package

# Копируем WAR файл в директорию Tomcat
RUN cp target/App42PaaS-Java-MySQL-Sample-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war
#RUN mkdir -p /usr/local/tomcat/webapps/ROOT && \
   # cp WebContent/Config.properties /usr/local/tomcat/webapps/ROOT/Config.properties

# Добавляем конфигурационный файл для JMX Exporter
COPY jmx_exporter_config.yml /usr/local/tomcat/webapps/jmx_exporter_config.yml

# Загружаем JMX Exporter
ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.16.1/jmx_prometheus_javaagent-0.16.1.jar /usr/local/tomcat/webapps/jmx_prometheus_javaagent.jar

# Настраиваем Tomcat для использования JMX Exporter и запускаем Tomcat
CMD ["catalina.sh", "run"]
