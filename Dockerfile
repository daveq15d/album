# Etapa de construcción
FROM gradle:7.6.0-jdk17 AS build
WORKDIR /app

# Copiar todo el código fuente al contenedor
COPY . .

# Ejecutar Gradle para construir el JAR (omitir tests si es necesario)
RUN ./gradlew build -x test

# Etapa de ejecución
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Copiar el JAR construido desde la etapa anterior
COPY --from=build /app/build/quarkus-app/quarkus-run.jar /app/app.jar
COPY --from=build /app/build/quarkus-app/lib/ /app/lib/
COPY --from=build /app/build/quarkus-app/app/ /app/app/
COPY --from=build /app/build/quarkus-app/quarkus/ /app/quarkus/

# Comando para ejecutar la aplicación Quarkus
CMD ["java", "-jar", "/app/app.jar"]




