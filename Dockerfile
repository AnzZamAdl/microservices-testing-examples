# First stage: Build JAR using Maven
FROM maven:3.9.0-eclipse-temurin-17 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package

# Second stage: Run the application with OpenJDK
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8081
CMD ["java", "-jar", "app.jar"]
