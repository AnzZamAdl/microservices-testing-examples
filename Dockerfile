# Use OpenJDK 17 as base image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the built JAR file (Replace `your-app.jar` with the actual filename)
COPY target/*.jar app.jar

# Expose the port the app runs on
EXPOSE 8081

# Command to run the application
CMD ["java", "-jar", "app.jar"]
