# Etapa de construcción
FROM eclipse-temurin:17.0.11_9-jdk-jammy AS build
WORKDIR /app

# Copiar todo el contenido del proyecto
COPY . .

# Dar permisos de ejecución al gradlew y construir la aplicación
RUN chmod +x ./gradlew
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



