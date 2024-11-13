# Build stage
FROM maven:3.8.5-openjdk-17 AS build
ARG SERVICE_NAME
ARG PORT

WORKDIR /usr/src/app

# Copy the parent POM file
COPY ./microservice-parent/pom.xml ./microservice-parent/pom.xml

# Copy all POM files for dependency resolution
COPY ./${SERVICE_NAME}/pom.xml ./${SERVICE_NAME}/

# Copy the specific service folder and its POM file
COPY ./${SERVICE_NAME}/src /usr/src/app/${SERVICE_NAME}/src

# Run Maven to clean and package the service, using the parent POM
WORKDIR /usr/src/app/${SERVICE_NAME}
RUN mvn clean package -DskipTests

# Runtime stage
FROM openjdk:17-jdk-slim AS runtime
ARG SERVICE_NAME
ARG PORT

# Set environment variables for runtime
ENV SERVICE_NAME=${SERVICE_NAME}
ENV PORT=${PORT}

WORKDIR /usr/src/app

# Install curl
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy the specific JAR file from the build stage
COPY --from=build /usr/src/app/${SERVICE_NAME}/target/${SERVICE_NAME}*.jar /usr/src/app/app.jar

# Expose the appropriate port based on the service
EXPOSE ${PORT}

# Start the application
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.jar"]
