FROM eclipse-temurin:17.0.11_9-jdk-jammy AS build
WORKDIR /app

# Copiar los archivos necesarios para la construcción
COPY gradle gradle
COPY gradlew build.gradle.kts settings.gradle.kts ./
COPY src src

# Dar permisos de ejecución a gradlew
RUN chmod +x ./gradlew

# Construir la aplicación
RUN ./gradlew build -Dquarkus.package.type=uber-jar

# Etapa de ejecución
FROM eclipse-temurin:17.0.11_9-jre-jammy
WORKDIR /app

# Copiar el jar generado desde la etapa de construcción
COPY --from=build /app/build/quarkus-app/quarkus-run.jar ./app.jar

# Exponer el puerto de la aplicación
EXPOSE 8080

# Comando para ejecutar la aplicación
CMD ["java", "-jar", "app.jar"]



