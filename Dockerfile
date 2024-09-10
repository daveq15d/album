FROM gradle:7.6.0-jdk17 AS build

COPY build.gradle settings.gradle /usr/src/app/
COPY src /usr/src/app/src/

WORKDIR /usr/src/app

RUN gradle build --no-daemon

FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=build /usr/src/app/build/libs/tu-app.jar /app/app.jar

CMD ["java", "-jar", "app.jar"]
