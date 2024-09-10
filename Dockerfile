# Fase de construcción
FROM gradle:7.6.0-jdk17 AS build

# Copia el build.gradle y los archivos del proyecto
COPY build.gradle settings.gradle /usr/src/app/
COPY src /usr/src/app/src/

# Establece el directorio de trabajo
WORKDIR /usr/src/app

# Compila el proyecto usando el plugin de Quarkus para Gradle
RUN gradle build --no-daemon

# Fase de ejecución
FROM eclipse-temurin:17-jre-alpine

# Establece el directorio de trabajo para la aplicación
WORKDIR /app

# Copia los archivos generados en la fase de construcción
COPY --from=build /usr/src/app/build/quarkus-app/lib/ /app/lib/
COPY --from=build /usr/src/app/build/quarkus-app/app/ /app/app/
COPY --from=build /usr/src/app/build/quarkus-app/quarkus/ /app/quarkus/
COPY --from=build /usr/src/app/build/quarkus-app/quarkus-run.jar /app/app.jar

# Ejecuta la aplicación al iniciar el contenedor
CMD ["java", "-jar", "app.jar"]

