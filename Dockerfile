# Этап сборки
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
# Скачиваем зависимости (кеширование)
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# Этап запуска
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# Порт приложения
EXPOSE 8090

# Запуск
ENTRYPOINT ["java", "-jar", "app.jar"]