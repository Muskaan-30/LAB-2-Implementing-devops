# ---- Build stage: compile with Gradle inside Docker
FROM gradle:8.7.0-jdk17 AS build
WORKDIR /app
COPY . .
# build a fat jar; skip tests to speed up CI if you want
RUN gradle clean build -x test --no-daemon

# ---- Runtime stage: lightweight JRE only
FROM eclipse-temurin:17-jre
WORKDIR /app
# copy whatever jar Gradle produced
COPY --from=build /app/build/libs/*.jar /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
